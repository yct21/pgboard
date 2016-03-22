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
  def handle_move(_, _map_module, %{players: players, board_map: board_map}) do
    card_deck = Pgboard.Game.CardDeck.basic_deck
    board = initialize_board(players, board_map, card_deck)
  end

  # subphase intialize_bard
  defp initialize_board(players, board_map, card_deck) do
    # deal with players
    # plant market and card deck
    # resources
    # cities
  end
end
