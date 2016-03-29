defmodule Pgboard.Game.PreparationPhase do
  @moduledoc """
  This module initializes a game using basic rule.
  """

  use Pgboard.Game.Phase, name: :preparation
  @default_initial_resources %{coal: 24, oil: 18, garbage: 6, uranium: 2}

  @doc """
  Set board up.

  current_move: %{
    map,
    players: [{id, name, avatar}]
  }

  returns:
    {:ok, new_board_state, logs_to_append}
    {:error, reason}
  """
  def handle_move(board_state) do
    {:ok, board_state, []}
    |> handle_map_module
    |> handle_initialize_players
    |> handle_initialize_player_order
    |> handle_initialize_card_deck
    |> handle_initialize_plant_market
    |> handle_initialize_resource_market
    |> handle_initialize_cities
    |> handle_expected_move
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
    board_state =
      board_state
      |> Map.put(:player_order, initial_order)
      |> Map.put(:table_order, initial_order)

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
      plant_for_auction: nil,
      discard_plant_needed: false
    }

    card_deck = Enum.slice(card_deck, 8..Enum.count(card_deck))
    board_state =
      board_state
      |> Map.put(:card_deck, card_deck)
      |> Map.put(:plant_market, plant_market)

    {:ok, board_state, logs_to_append}
  end

  subphase :handle_initialize_resource_market do
    resource_market = @default_initial_resources
    board_state = Map.put(board_state, :resource_market, resource_market)

    {:ok, board_state, logs_to_append}
  end

  subphase :handle_initialize_cities do
    cities =
      board_state.map_module.cities
      |> Enum.map(fn({city_name, _city_props}) -> {city_name, :not_selected} end)
      |> Enum.into(%{})

    board_state = Map.put(board_state, :cities, cities)
    {:ok, board_state, logs_to_append}
  end

  subphase :handle_expected_move do
    expected_move = %{
      player: List.first(board_state.player_order),
      current_phase: :pick_region
    }

    map_name_in_log =
      board_state.map
      |> Atom.to_string
      |> String.upcase
    log = {:system, "Setup board with #{map_name_in_log} map."}

    board_state =
      board_state
      |> Map.put(:game_step, 1)
      |> Map.put(:expected_move, expected_move)

    {:ok, board_state, logs_to_append ++ [log]}
  end

  defp process_player({{id, name, avatar}, color}) do
    initial_resources = %{
      coal: 0,
      oil: 0,
      garbage: 0,
      uranium: 0
    }

    _processed_player = {
      id,
      %{
        name: name,
        avatar: avatar,
        color: color,
        funds: 0,
        plants: [],
        resources: initial_resources
      }
    }
  end
end
