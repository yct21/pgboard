defmodule Pgboard.Game.PlantAuction do
  @moduledoc """
  Handles everything happens in plant auction phase.

           abort
      ┌──────────────┐
      │              │
      │              ▼
      │  ┌──────────────────────┐
      └──│    before_auction    │──────────────────────┬────────────────────────────┐
         └───────────┬──────────┘                      │                            │
                     │       ▲                         │                            │
                     │       │                         │                            │
           pick plant│       │                         │ pick plant           abort │
                     │       │                         │                            │
                     │       │                         ▼                            │
                     │       │                ┌────────────────┐                    │
                     ▼       └────────────────┤                │                    ▼
         ┌──────────────────────┐             │   purchasing   │            ┌──────────────┐
      ┌─▶│      in_auction      │────────────▶│  (temporary)   │───────────▶│  next_phase  │
      │  └──────────────────────┘    pass     │                │            └──────────────┘
      │              │                        └──────┬─────────┘
      │     bid      │                               │   ▲
      └──────────────┘                               │   │ discard plant
                                                     │   │
                                                     ▼   │
                                             ┌───────────┴─────────┐
                                             │   too_many_plants   │
                                             └─────────────────────┘

  ## Plant market data structure

  Data structure of plant market consists of:

  - available_plants
  - future_plants
  - bid_table: %{player_id: bid_offer}
  - auction_status

  See `backend/game/board.ex` for all parts of `Pgboard.Game.Board` data structure.

  ## `auction_status`

  `auction_status` could be one of below:

  - :before_auction
  - {:in_auction, plant_for_auction}
  - {:purchasing, plant_for_auction}
  - :next_phase
  - {:too_many_plants, plant_bought}

  When game comes to plant auction phase the auction_status is set to :before_auction.
  `purchasing` is a temporary status that happens only in the middle of handling process. Frontend could only get one of other 4 statuses.
  `plant_market` works as a state machine by consuming player moves until `auction_status` turns into status `next_phase`.

  ## Allowed player move.

  - %{type: "pick_plant", player, picked_plant} when auction_status == :before_auction
  - %{type: "abort_picking", player} when auction_status == :before_auction
  - %{type: "make_bid", player, bid_offer} when auction_status == :in_auction
  - %{type: "pass_bid", player} when auction_status_status == :in_auction
  - %{type: "discard_plant", player, discarded_plant, expected_resources} == :too_many_plants
  """

  use Pgboard.Game.Phase, name: :plant_auction

  # Market size in each step.
  # step => {available_market_size, future_market_size}
  @market_size %{
    1 => {4, 4},
    2 => {4, 4},
    3 => {6, 0}
  }

  @max_plants_per_player 3

  @doc """
  Process player move in plant auction phase.
  """
  def handle_move(board_state) do
    {:ok, board_state, []}
    |> handle_move_type
    |> handle_current_auction
    |> handle_purchasing
    |> handle_next_auction
    |> handle_card_deck
    |> handle_next_phase
  end

  subphase :handle_move_type do
    # Eliminate the warning of unused variable logs_to_append
    _logs_to_append = logs_to_append

    case board_state.current_move.type do
      "pick_plant" -> pick_plant(board_state)
      "abort_picking" -> abort_picking(board_state)
      "make_bid" -> make_bid(board_state)
      "pass_bid" -> pass_bid(board_state)
      "discard_plant" -> discard_plant(board_state)
    end
  end

  # Find next player to bid if an auction goes on.
  # Or some buyer purchase this plant.
  subphase :handle_current_auction do
    ~m{plant_market current_move table_order}a = board_state
    ~m{bid_table auction_status}a = plant_market
    current_player = current_move.player

    if {:in_auction, plant_for_auction} = auction_status do
      player_number_in_auction = Enum.count bid_table, fn({_, state}) ->
        !(state in [:aborted, :passed, :bought])
      end

      cond do
        # Auction ends since a winner is here.
        player_number_in_auction == 1 ->
          processed_auction_status = {:purchasing, plant_for_auction}
          processed_board_state = put_in board_state.plant_market.auction_status, processed_auction_status

          {:ok, processed_board_state, logs_to_append}

        # Or auction goes on.
        player_number_in_auction > 1 ->
          {players_before, players_after} = Enum.split_while table_order, &(&1 != current_player)
          processed_order = players_after ++ players_before

          next_player_to_bid = Enum.find processed_order, fn(player) ->
            player != current_player && not(bid_table[player] in [:bought, :abort, :pass])
          end

          expected_move = %{player: next_player_to_bid, current_phase: @phase_name}
          processed_board_state = Map.put board_state, :expected_move, expected_move

          {:ok, processed_board_state, logs_to_append}
      end
    else
      # Pass to next subphase if auction is not on.
      {:ok, board_state, logs_to_append}
    end
  end

  subphase :handle_purchasing do
    ~m{plant_market player_order players}a = board_state
    ~m{bid_table auction_status} = plant_market

    if {:purchasing, plant_for_auction} = auction_status do
      buyer = Enum.find player_order, &(player_in_auction?(&1, bid_table))
      buyer_plant_amount = Enum.count board_state.players[buyer].plants

      cond do
        # Could not have it right now since plants are limited to 3 per player.
        buyer_plant_amount == @max_plants_per_player ->
          processed_auction_status = {:too_many_plants, plant_for_auction}
          expected_move = %{player: buyer, current_phase: @phase_name}

          processed_board_state =
            board_state
            |> put_in([:plant_market, :auction_status], processed_auction_status)
            |> Map.put(:expected_move, expected_move)

          {:ok, processed_board_state, logs_to_append}

        # Or a purchase is happening.
        buyer_plant_amount >= 0 && buyer_plant_amount < @max_plants_per_player ->
          final_offer = bid_table[buyer]
          processed_bid_table =
            bid_table
            |> Map.put(buyer, :bought)
            |> Enum.reduce(%{}, fn({player, bid_offer}, acc) ->
                 reset_bid_offer =
                   case bid_offer do
                     :passed -> :blank
                     _ -> bid_offer
                   end

                 Map.put acc, player, reset_bid_offer
               end)

          processed_board_state =
            board_state
            |> update_in([:players, buyer, :funds], &(&1 - final_offer))
            |> update_in([:players, buyer, :plants], &(&1 ++ [plant_for_auction]))
            |> update_in([:plant_market, :available_plants], &(&1 -- plant_for_auction))
            |> put_in([:plant_market, :bid_table], processed_bid_table)
            |> put_in([:plant_market, :auction_status], :before_auction)

          buyer_name = players[buyer].name
          log = "#{buyer_name} purchased plant ##{plant_for_auction} with $#{final_offer}."

          {:ok, processed_board_state, logs_to_append ++ [log]}
      end
    else
      # Pass to next subphase since no purchase in happening now.
      {:ok, board_state, logs_to_append}
    end
  end

  subphase :handle_next_auction do
    ~m{plant_market player_order}a = board_state
    ~m{bid_table auction_status}a = plant_market

    if auction_status == :before_auction do
      next_player_to_pick = Enum.find player_order, &(bid_table[&1] == :blank)

      case next_player_to_pick do
        # This phase is over.
        nil ->
          processed_board_state = put_in board_state.plant_market.auction_status, :next_phase
          {:ok, processed_board_state, logs_to_append}

        # This isn't over.
        _ ->
          expected_move = %{player: next_player_to_pick, current_phase: @phase_name}
          processed_board_state = Map.put board_state, :expected_move, expected_move

          {:ok, processed_board_state, logs_to_append}
      end
    else
      # Pass to next subphase since auction is on.
      {:ok, board_state, logs_to_append}
    end
  end

  subphase :handle_card_deck do
    alias Pgboard.Game.CardDeck
    ~m{plant_market players card_deck game_step}a = board_state
    ~m{available_plants}a = plant_market

    {expected_available_size, expected_future_size} = @market_size[game_step]
    if Enum.count(available_plants) < expected_available_size do
      max_plant_amount =
        players
        |> Enum.map(fn(_, %{plants: plants}) -> Enum.count(plants) end)
        |> Enum.max

      {refilled_available_market, refilled_future_market, processed_card_deck} =
        CardDeck.refill_market(plant_market, card_deck, expected_available_size, expected_future_size, max_plant_amount)

      processed_plant_market =
        plant_market
        |> Map.put(:available_plants, refilled_available_market)
        |> Map.put(:future_plants, refilled_future_market)

      processed_board_state =
        board_state
        |> Map.put(:plant_market, processed_plant_market)
        |> Map.put(:card_deck, processed_card_deck)

      {:ok, processed_board_state, logs_to_append}
    else
      {:ok, board_state, logs_to_append}
    end
  end

  subphase :handle_next_phase do
    ~m{plant_market player_order game_round game_step cities players}a = board_state
    ~m{auction_status available_plants future_plants}a = plant_market

    if auction_status == :next_phase do
      # Player order should be shuffled after plant auction only in round 1.
      processed_player_order =
        case game_round do
          1 -> Pgboard.Game.Board.reorder_players(players, cities)
          _ -> player_order
        end

      # When step3 card apears in plant auction phase, it should be removed at end of phase, as well as
      # the plant with minimum id. Game advance to step 3 afterwards.
      step3_appears = Enum.any? future_plants, &(&1 == :step3)
      processed_plant_market =
        case step3_appears do
          false -> plant_market
          true ->
            processed_available_plants = available_plants ++ future_plants -- [:step3] -- List.first(available_plants)
            %{auction_status: :next_phase, available_plants: processed_available_plants, future_plants: []}
        end
      processed_game_step =
        case step3_appears do
          false -> game_step
          true -> :step3
        end

      expected_move = %{phase: :resource_purchase, player: List.last(processed_game_step)}
      processed_board_state =
        board_state
        |> Map.put(:plant_market, plant_market)
        |> Map.put(:game_step, processed_game_step)
        |> Map.put(:expected_move, expected_move)

      {:ok, board_state, logs_to_append}
    else
      # Nothing happens since still in current phase
      {:ok, board_state, logs_to_append}
    end
  end

  defp pick_plant(board_state) do
    ~m{current_move players plant_market}a = board_state
    ~m{bid_table auction_status}a = plant_market
    ~m{player picked_plant bid_offer}a = current_move

    cond do
      # Bad endings.
      bid_table[player] != :blank ->
        {:error, "Current player not able to pick."}

      auction_status != :before_auction ->
        {:error, "Incorrect status."}

      bid_offer > players[player].funds ->
        {:error, "Not enough funds."}

      # Happy ending.
      true ->
        processed_auction_status = {:in_auction, picked_plant}
        processed_board_state =
          board_state
          |> put_in([:plant_market, :auction_status], processed_auction_status)
          |> put_in([:plant_market, :bid_table, player], bid_offer)

        player_name = players[player].name
        log = "#{player_name} picked Plant ##{picked_plant} for auction with $#{bid_offer} initially."

        {:ok, processed_board_state, [log]}
    end
  end

  defp abort_picking(board_state) do
    ~m{current_move players plant_market}a = board_state
    ~m{bid_table auction_status}a = plant_market
    ~m{player}a = current_move

    cond do
      # Bad endings.
      bid_table[player] != :blank ->
        {:error, "Current player not able to abort."}

      auction_status != :before_auction ->
        {:error, "Incorrect status."}

      # Happy ending.
      true ->
        processed_board_state =
          board_state
          |> put_in([:plant_market, :auction_status], :before_auction)
          |> put_in([:plant_market, :bid_table, player], :aborted)

        player_name = players[player].name
        log = "#{player_name} aborted his/her chance to pick."

        {:ok, processed_board_state, [log]}
    end
  end

  defp make_bid(board_state) do
    ~m{current_move players plant_market}a = board_state
    ~m{bid_table auction_status}a = plant_market
    ~m{player bid_offer}a = current_move
    {:in_auction, plant_for_auction} = auction_status

    cond do
      # Bad endings.
      !player_in_auction?(player, bid_table) ->
        {:error, "Current player not able to make bid."}

      bid_offer > players[player].funds ->
        {:error, "Not enough funds"}

      # Happy ending.
      true ->
        processed_board_state = put_in board_state.plant_market.bid_table[player], bid_offer

        player_name = players[player].name
        log = "#{player_name} bid $#{bid_offer} for Plant ##{plant_for_auction}."

        {:ok, processed_board_state, [log]}
    end
  end

  defp pass_bid(board_state) do
    ~m{current_move players plant_market}a = board_state
    ~m{bid_table auction_status}a = plant_market
    ~m{player}a = current_move
    {:in_auction, plant_for_auction} = auction_status

    cond do
      # Bad endings.
      !player_in_auction?(player, bid_table) ->
        {:error, "Current player not able to pass."}

      # Happy ending.
      true ->
        processed_board_state = put_in board_state.plant_market.bid_table[player], :passed

        player_name = players[player].name
        log = "#{player_name} passed in auction for Plant ##{plant_for_auction}."

        {:ok, processed_board_state, [log]}
    end
  end

  defp discard_plant(board_state) do
    ~m{current_move players plant_market}a = board_state
    ~m{bid_table auction_status}a = plant_market
    ~m{player discarded_plant expected_resources}a = current_move
    {:too_many_plants, plant_bought} = auction_status

    cond do
      # Bad endings.
      !player_in_auction?(player, bid_table) ->
        {:error, "Current player not able to discard some plant."}

      !(discarded_plant in players[player].plants) ->
        {:error, "Discarding a plant player does not own."}

      Pgboard.Game.Board.resource_exceed_limit?(expected_resources, players[player].plants ++ [plant_bought] -- [discarded_plant]) ->
        {:error, "Remaining resouces out of limit."}

      # Happy ending.
      true ->
        processed_player_plants = List.delete board_state.players[player].plants, discarded_plant
        processed_auction_status = {:purchasing, plant_bought}
        processed_board_state =
          board_state
          |> put_in([:players, player, :plants], processed_player_plants)
          |> put_in([:plant_market, :auction_status], processed_auction_status)

        player_name = players[player].name
        log = "#{player_name} discarded Plant ##{discarded_plant} for Plant ##{plant_bought}."

        {:ok, processed_board_state, [log]}
    end
  end

  defp player_in_auction?(player, bid_table) do
    !(bid_table[player] in [:aborted, :passed, :bought])
  end
end
