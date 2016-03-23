defmodule Pgboard.Game.PreparationPhase do
  @moduledoc """
  This module initializes a game with basic rule.
  """

  @doc """
  Initialize a game.

  current_move: %{
    map,
    players: [{id, name, avatar}]
  }

  returns:
    {:ok, new_board_state, logs_to_append}
    {:error, reason}
  """

  use Pgboard.Game.Phase, name: :preparation
  @default_initial_resources %{coal: 24, oil: 18, garbage: 6, uranium: 2}

  def handle_move(board_state) do
    {:ok, board_state, []}
    |> handle_map_module
    |> handle_initialize_players
    |> handle_initialize_player_order
    |> handle_initialize_card_deck
    |> handle_initialize_plant_market
    |> handle_initialize_resource_market
  end

  subphase :handle_map_module do
    %{map: map} = board_state.current_move
    map_module = Pgboard.Game.Arbiter.get_map_module(map)

    board_state =
      board_state
      |> Map.put(:map, map)
      |> Map.put(:map_module, map_module)

    {:ok, board_state, logs_to_append}
  end

  subphase :handle_initialize_players do
    player_amount = Enum.count board_state.current_move.players
    player_colors = Enum.take_random [:purple, :red, :blue, :pink, :orange, :black], player_amount

    players =
      board_state.current_move.players
      |> Enum.zip(player_colors)
      |> Enum.map(&process_player/1)
      |> Enum.into(%{})

    board_state = Map.put(board_state, :players, players)

    {:ok, board_state, logs_to_append}
  end

  subphase :handle_initialize_player_order do
    player_ids = Map.keys board_state.players
    initial_order = Enum.shuffle player_ids

    # table_order and player_order are assigned with same sequence at beginning of game.
    board_state = Map.put(board_state, :player_order, initial_order)
    board_state = Map.put(board_state, :table_order, initial_order)

    {:ok, board_state, logs_to_append}
  end

  subphase :handle_initialize_card_deck do
    player_amount = Enum.count board_state.players
    card_deck = Pgboard.Game.CardDeck.basic_deck(player_amount)

    board_state = Map.put board_state, :card_deck, card_deck

    {:ok, board_state, logs_to_append}
  end

  subphase :handle_initialize_plant_market do
    card_deck = board_state.card_deck
    bid_table =
      board_state.players
      |> Enum.map(fn({player_id, _}) -> {player_id, nil} end)
      |> Enum.into(%{})

    plant_market = %{
      available_plants: Enum.slice(card_deck, 0..3),
      future_plants: Enum.slice(card_deck, 4..7),
      bid_table: bid_table,
      plant_for_auction: nil
    }

    card_deck = Enum.slice(card_deck, 8..Enum.count(card_deck))
    board_state = Map.put(board_state, :card_deck, card_deck)
    board_state = Map.put(board_state, :plant_market, plant_market)

    {:ok, board_state, logs_to_append}
  end

  subphase :handle_initialize_resource_market do
    resource_market = @default_initial_resources
    board_state = Map.put(board_state, :resource_market, resource_market)

    {:ok, board_state, logs_to_append}
  end

  defp process_player({{id, name, avatar}, color}) do
    initial_resources = %{
      coal: 0,
      oil: 0,
      garbage: 0,
      uranium: 0
    }

    {id, %{name: name, avatar: avatar, color: color, plants: [], resources: initial_resources}}
  end
end
