defmodule Pgboard.Game.Board do
  @moduledoc """
  This module defines helper methods for board state.

  ```
  board: %{
    game_step,
    card_deck,
    current_move/expected_move: {
      player,
      current_phase,
      payload
    },
    map: "germany",
    map_module: Pgboard.Game.GermanyMap,
    player_order,
    table_order,
    players: %{
      player_id => %{
        name,
        avatar,
        color,
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
  ```
  """


end
