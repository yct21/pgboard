defmodule Pgboard.Game.Board do
  @moduledoc """
  This module defines helper methods for board state

  board: %{
    current_step,
    current_player,
    current_phase,
    card_deck,
    map: "germany",
    players: %{
      player_id => %{
        name,
        id,
        avatar,
        plants,
        resources
      }
    },
    plant_market: %{
      available_market: [3, 4, 5, 6],
      future_market: [7, 8, 9,10],
      plant_for_auction: 5,
      bid_table: %{player_id: bid_offer}
    },
    resource_market: %{
      resource: amount
    },
    cities: {
      city_name: [owners] / :banned / :not_selected / :selected
    }
  }
  """


end
