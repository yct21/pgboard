defmodule Pgboard.Game.Arbiter do
  @moduledoc """
  This module is to handle player moves by routing it to corresponding map module,
  while providing basic rule handler for every map.

  Method `handle_move` is defined in macro `game_map`.
  Remember to plug all the game maps before game phases.

  handle_move(current_board_state, move) returns:
    {:ok, new_board_state, logs_to_append}
    {:error, reason}
  """

  use Pgboard.Game.BoardMap.Plug
  use Pgboard.Game.Phase.Plug

  game_map Pgboard.Game.GermanyMap
  game_map Pgboard.Game.UsaMap

  game_phase Pgboard.Game.InitializePhase
end
