defmodule Pgboard.Game.InitializePhase do
  @moduledoc """
  This module initializes a game with basic rule.
  """

  @doc """
  Initialize board and card deck.
  Parameters does not matter.

  returns:
    {:ok, new_board_state, new_card_deck, logs_to_append}
  """
  def handle_move(_, _, %{players: players, board_map: board_map}) do
    card_deck = Pgboard.Game.CardDeck.basic_deck
  end

  # defp
end
