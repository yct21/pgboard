defmodule Pgboard.Game.PreparationPhase do
  use Pgboard.Game.Phase, name: :preparation

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
  def handle_move(board_state) do
    {:ok, board_state, []}
    |> handle_map_module
    |> handle_initialize_players
    |> handle_initialize_player_order
  end

  # Put map module to the board
  subphase :handle_map_module do
    %{map: map} = board_state.current_move
    map_module = Pgboard.Game.Arbiter.get_map_module(map)

    board_state =
      board_state
      |> Map.put(:map, map)
      |> Map.put(:map_module, map_module)

    {:ok, board_state, logs_to_append}
  end

  # Initialize players in board
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

  # Initialize table_order and player_order.
  # These two are assigned with same sequence at beginning of game.
  subphase :handle_initialize_player_order do
    player_ids = Map.keys board_state.players
    initial_order = Enum.shuffle player_ids

    board_state = Map.put(board_state, :player_order, initial_order)
    board_state = Map.put(board_state, :table_order, initial_order)

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
