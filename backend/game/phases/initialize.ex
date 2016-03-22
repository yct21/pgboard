defmodule Pgboard.Game.InitializePhase do
  use Pgboard.Game.Phase, name: :initialize

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
    # |> handle_initialize_players
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
    players =
      board_state.current_move.players
      |> Enum.map(&process_player/1)

  end

  defp process_player({id, name, avatar}) do
    initial_resources = %{
      coal: 0,
      oil: 0,
      garbage: 0,
      uranium: 0
    }

    {id, %{name: name, avatar: avatar, plants: [], resources: initial_resources}}
  end
end
