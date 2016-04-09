defmodule Pgboard.Game.Board do
  @moduledoc """
  This module defines helper methods for board state.

  ```
  board: %{
    game_step,
    game_round,
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
        funds,
        plants,
        resources
      }
    },
    plant_market: %{
      available_plants: [3, 4, 5, 6],
      future_plants: [7, 8, 9,10],
      bid_table: %{
        player_id: bid_offer
      },
      auction_status:
        :before_auction
        {:in_auction, plant_for_auction}
        {:purchasing, plant_for_auction}
        :next_phase
        {:too_many_plants, plant_bought}
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

  import ShortMaps

  @doc """
  Reorder players by his/her city amounts and max plant number.

  It happens in bureaucracy phase of every rounds and specially after plant auction phase in round 1.
  """
  def reorder_players(players, board_cities) do
    player_city_amount = player_city_amount(Map.keys(players), board_cities)

    players
    |> Enum.sort(fn({player1, %{plants: player1_plants}}, {player2, %{plants: player2_plants}}) ->
         if player_city_amount[player1] != player_city_amount[player2] do
           player_city_amount[player1] >= player_city_amount[player2]
         else
           Enum.max(player1_plants) > Enum.max(player2_plants)
         end
       end)
    |> Enum.map(fn({player, _}) -> player end)
  end

  @doc """
  Count cities for every player.
  """
  def player_city_amount(player_ids \\ [], board_cities) do
    initial_count = for player_id <- player_ids, into: %{}, do: {player_id, 0}

    Enum.reduce board_cities, initial_count, fn({_city, city_state}, acc) ->
      cond do
        is_list(city_state) ->
          Enum.reduce city_state, acc, fn(city_owner, acc) ->
            Map.update acc, city_owner, 1, &(&1 + 1)
          end

        true -> acc
      end
    end
  end

  @doc """
  Check if stored resources exceed limit.
  """
  def resource_exceed_limit?(resources, plants) do
    ~m{coal oil garbage uranium}a = resources
    initial_resources = %{coal: 0, oil: 0, garbage: 0, uranium: 0, hybrid: 0}

    limit = Enum.reduce plants, initial_resources, fn(plant_id, acc) ->
      {required_resources, type, _} = Pgboard.Game.CardDeck.plant(plant_id)
      Map.update! acc, type, &(&1 + required_resources * 2)
    end

    hybrid =
      cond do
        coal > limit.coal && oil <= limit.oil -> coal - limit.coal
        oil > limit.oil && coal <= limit.coal -> oil - limit.oil
        coal > limit.coal && oil > limit.oil -> coal - limit.coal + oil - limit.oil
        true -> 0
      end

    (hybrid > limit.hybrid) || (garbage > limit.garbage) || (uranium > limit.uranium)
  end
end
