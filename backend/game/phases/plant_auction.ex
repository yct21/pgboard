defmodule Pgboard.Game.PlantActionPhase do
  @moduledoc """
  This is a bit complicated.

```
    ┌────────────────────────────────────────┐
    │                                        │
    │                                        │
    │                              abort     │
    │                         ┌──────────────┤
    │                         │              │
    │                         │              ▼
    │                         │  ┌──────────────────────┐      pick or abort
    │              ┌──────────┴──│   prepare_auction    │────────────────────────────┐
    │              │             └─────┬────────────────┘                            │
    │              │                   │          ▲                                  │
    │              │                   │          │                                  │
    │              │                   │          │                                  │
    │              │        pick plant │          │  pass                            │
    │              │                   │          │                                  │
    │              │                   │          │                                  │
    │              │                   ▼          │                                  ▼
    │    pick plant│             ┌────────────────┴─────┐     abort      ┌──────────────────────┐
    │              │          ┌─▶│      in_auction      │──────────────▶ │      next_phase      │
    │              │          │  └────────────────┬─────┘                └──────────────────────┘
    │              │          │              │    │                                  ▲
    │              │          │     bid      │    │                                  │
    │              │          └──────────────┘    │                                  │
    │              │                              │  pass                            │
    │              │                              │                                  │
    │              │                              │                                  │
    │              │                              ▼                                  │
    │              │             ┌──────────────────────┐          discard plant     │
    │              └────────────▶│   too_many_plants    │────────────────────────────┘
    │                            └──────────────────────┘
    │            discard plant               │
    └────────────────────────────────────────┘
```
  """
  use Pgboard.Game.Phase, name: :plant_auction

  @max_plants_per_player 3

  @doc """
  Whatever happens starts here.
  """
  def handle_move(%{current_move: %{type: :pick_plant}} = board_state) do
    {:ok, board_state, []}
    |> handle_move_type
    |> handle_current_auction
    |> handle_next_auction
    # |> handle_card_deck
    # |> handle_step3_card
    # |> handle_next_phase
  end

  subphase :handle_move_type do
    # Eliminate the warning of unused variable logs_to_append
    _logs_to_append = logs_to_append

    case board_state.current_move.type do
      :pick_plant -> pick_plant(board_state)
      :abort_picking -> abort_picking(board_state)
      :make_bid -> make_bid(board_state)
      :pass_bid -> pass_bid(board_state)
      :discard_plant -> discard_plant(board_state)
    end
  end

  # Find next player to bid if an auction goes on.
  # Or some buyer purchase this plant.
  subphase :handle_current_auction do
    ~m{plant_market}a = board_state
    ~m{bid_table plant_for_auction} = plant_market

    # Check if an auction is ongoing currently.
    player_number_in_auction = Enum.count bid_table, fn({_, state}) ->
      !(state in [:aborted, :passed, :bought])
    end

    cond do
      # Pass to next handler if no auction happens.
      !plant_for_auction -> {:ok, board_state, logs_to_append}
      # Or else...
      player_number_in_auction == 0 -> {:error, "An auction is on but no one could bid"}
      player_number_in_auction == 1 -> purchase_plant(board_state, logs_to_append)
      player_number_in_auction >= 2 -> next_player_to_bid(board_state, logs_to_append)
    end
  end

  subphase :handle_next_auction do
    ~m{plant_market expected_move} = board_state
    ~m{plant_for_auction} = plant_market

    cond do
      # Pass to next handler since no need to initialize an auction.
      plant_for_auction || expected_move -> {:ok, board_state, logs_to_append}
      # Or find the next player for auction
      true -> next_player_to_pick(board_state, logs_to_append)
    end
  end

  subphase :handle_card_deck do

  end
  #
  # subphase :handle_next_phase do
  #
  # end

  defp pick_plant(board_state) do
    ~m{current_move players plant_market}a = board_state
    ~m{plant_for_auction bid_table discard_plant_needed}a = plant_market
    ~m{player picked_plant bid_offer}a = current_move

    cond do
      # Bad endings.
      bid_table[player] != :blank ->
        {:error, "Current player not able to pick."}

      discard_plant_needed ->
        {:error, "Some player has too many plants."}

      plant_for_auction ->
        {:error, "Last auction not ended."}

      bid_offer > players[player].funds ->
        {:error, "Not enough funds"}

      # Happy ending.
      true ->
        board_state = put_in board_state.plant_market.plant_for_auction, picked_plant
        board_state = put_in board_state.plant_market.bid_table[player], bid_offer

        player_name = players[player].name
        log = "#{player_name} picked Plant ##{picked_plant} for auction with $#{bid_offer} initially."

        {:ok, board_state, [log]}
    end
  end

  defp abort_picking(board_state) do
    ~m{current_move players plant_market}a = board_state
    ~m{plant_for_auction bid_table discard_plant_needed}a = plant_market
    ~m{player}a = current_move

    cond do
      # Bad endings.
      bid_table[player] != :blank ->
        {:error, "Current player not able to abort."}

      discard_plant_needed ->
        {:error, "Some player has too many plants."}

      plant_for_auction ->
        {:error, "Last auction not ended."}

      # Happy ending.
      true ->
        board_state = put_in board_state.plant_market.bid_table[player], :aborted

        player_name = players[player].name
        log = "#{player_name} aborted his/her chance to pick."

        {:ok, board_state, [log]}
    end
  end

  defp make_bid(board_state) do
    ~m{current_move players plant_market}a = board_state
    ~m{plant_for_auction bid_table discard_plant_needed}a = plant_market
    ~m{player bid_offer}a = current_move

    cond do
      # Bad endings.
      bid_table[player] in [:bought, :aborted, :passed] ->
        {:error, "Current player not able to make bid."}

      plant_for_auction == nil ->
        {:error, "Auction not happens."}

      discard_plant_needed ->
        {:error, "Some player has too many plants."}

      bid_offer > players[player].funds ->
        {:error, "Not enough funds"}

      # Happy ending.
      true ->
        board_state = put_in board_state.plant_market.bid_table[player], bid_offer

        discard_plant_needed ->
          {:error, "Some player has too many plants."}

        player_name = players[player].name
        log = "#{player_name} bid $#{bid_offer} for Plant ##{plant_for_auction}."

        {:ok, board_state, [log]}
    end
  end

  defp pass_bid(board_state) do
    ~m{current_move players plant_market}a = board_state
    ~m{plant_for_auction bid_table discard_plant_needed}a = plant_market
    ~m{player}a = current_move

    cond do
      # Bad endings.
      bid_table[player] in [:bought, :aborted, :passed] ->
        {:error, "Current player not able to pass."}

      discard_plant_needed ->
        {:error, "Some player has too many plants."}

      plant_for_auction == nil ->
        {:error, "Auction not happens."}

      # Happy ending.
      true ->
        board_state = put_in board_state.plant_market.bid_table[player], :passed

        player_name = players[player].name
        log = "#{player_name} passed in auction for Plant ##{plant_for_auction}."

        {:ok, board_state, [log]}
    end
  end

  defp discard_plant(board_state) do
    ~m{current_move players plant_market}a = board_state
    ~m{plant_for_auction bid_table discard_plant_needed}a = plant_market
    ~m{player discarded_plant}a = current_move

    cond do
      # Bad endings.
      bid_table[player] in [:bought, :aborted, :passed] ->
        {:error, "Current player not able to discard some plant."}

      !discard_plant_needed ->
        {:error, "Why are you doing this..."}

      !(discarded_plant in players[player].plants) ->
        {:error, "Discarding a plant player does not own."}

      plant_for_auction == nil ->
        {:error, "Auction not happens."}

      # Happy ending.
      true ->
        player_plants = List.delete board_state.players[player].plants, discarded_plant
        board_state = put_in board_state.plant_market.discard_plant_needed, false
        board_state = put_in board_state.players[player].plants, player_plants

        player_name = players[player].name
        log = "#{player_name} discarded Plant ##{discarded_plant} for Plant ##{plant_for_auction}."

        {:ok, board_state, [log]}
    end
  end

  defp next_player_to_bid(board_state, logs_to_append) do
    ~m{current_move plant_market table_order}a = board_state
    ~m{bid_table}a = plant_market
    current_player = current_move.player

    {players_before, players_after} = Enum.split_while table_order, (fn(player) -> player != current_player end)
    table_order = players_after ++ players_before

    next_player_to_bid = Enum.find table_order, fn(player) ->
      player != current_player && not(bid_table[player] in [:bought, :abort, :pass])
    end

    expected_move = %{current_phase: @phase_name, player: next_player_to_bid}
    board_state = Map.put board_state, :expected_move, expected_move

    {:ok, board_state, logs_to_append}
  end

  defp purchase_plant(board_state, logs_to_append) do
    ~m{players plant_market}a = board_state
    ~m{bid_table plant_for_auction}a = plant_market

    {buyer, bid_offer} = Enum.find bid_table, fn({_player, status}) ->
      is_integer(status)
    end

    buyer_plants_count = Enum.count(players[buyer].plants)

    cond do
      # Bad endings.
      players[buyer].funds < bid_offer -> {:error, "Not sufficient funds to purchase."}
      !plant_for_auction -> {:error, "Where is the plant..."}

      # Happy ending.
      buyer_plants_count < @max_plants_per_player ->
        bid_table = Enum.each(bid_table, %{}, fn({player, status}, refreshed_table) ->
          cond do
            is_integer(status) || status == :passed -> Map.put refreshed_table, player, :blank
            true -> Map.put refreshed_table, player, bid_table[player]
          end
        end)

        available_plants = plant_market.available_plants -- [plant_for_auction]
        plant_market = Enum.merge plant_market, ~m{bid_table available_plants}
        plant_market = Enum.put plant_market, :plant_for_auction, nil

        buyer_info =
          players[buyer]
          |> Map.update!(:funds, fn(funds) -> funds - bid_offer end)
          |> Map.update!(:plants, fn(plants) -> plants ++ [plant_for_auction] end)

        board_state = put_in board_state.players[buyer], buyer_info
        board_state = Map.put board_state, :plant_market, plant_market
        {:ok, board_state, logs_to_append}

      # True ending.
      true ->
        # Acutually it is the buyer possessing too many plants...
        expected_move = %{player: buyer, current_phase: @phase_name}
        board_state = put_in board_state.plant_market.discard_plant_needed, true
        board_state = Map.put board_state, :expected_move, expected_move

        {:ok, board_state, logs_to_append}
    end
  end

  defp next_player_to_pick(board_state, logs_to_append) do
    ~m{player_order}a = board_state
    ~m{bid_table} = board_state

    next_player = Enum.find player_order, fn(player) ->
      !(bid_table[player] in [:aborted, :passed, :bought])
    end

    if next_player do
      expected_move = %{player: next_player, current_phase: @phase_name}
      board_state = Map.put board_state, :expected_move, expected_move
    end

    {:ok, board_state, logs_to_append}
  end
end
