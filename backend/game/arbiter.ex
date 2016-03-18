defmodule Pgboard.Game.Arbiter do
  @moduledoc """
  This module is to handle player moves by routing it to corresponding map module,
  while providing basic rule handler for every map.

  Method `handle_move` is defined in macro `game_map`.

  handle_move(current_board_state, current_card_deck, move) returns:
    {:ok, new_board_state, new_card_deck, logs_to_append}
    {:error, reason}
  """

  use Pgboard.Game.BoardMap.Plug

  game_map Pgboard.Game.GermanyMap
  game_map Pgboard.Game.UsaMap
end
