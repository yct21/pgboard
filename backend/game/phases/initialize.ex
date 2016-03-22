defmodule Pgboard.Game.InitializePhase do
  use Pgboard.Game.Phase

  @moduledoc """
  This module initializes a game with basic rule.
  """

  @doc """
  Initialize board and card deck.
  ~~Parameters does not matter.~~

  returns:
    {:ok, new_board_state, logs_to_append}
    {:error, reason}
  """
  def handle_move(current_board_state, map_module) do
    {:ok, current_board_state, map_module, []}
    |> initialize_players
  end

  subphase :initialize_players do

  end
end
