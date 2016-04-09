defmodule Pgboard.Game.BoardTest do
  use ExUnit.Case, async: true
  alias Pgboard.Game.Board

  test "reorder players" do
    test_cases = [
      # {player_ids, player_city_amount, player_plants}, expected_result
      {{[3, 4, 1, 2], [7, 3, 4, 1], [[3, 5, 7], [20], [6, 8], [7]]}, [3, 1, 4, 2]},
      {{[90, 7 ,42, 25, 24], [9, 6, 6, 6, 5], [[11], [3, 17, 11], [16], [25, 9], [42]]}, [90, 25, 7, 42, 24]}
    ]

    Enum.each test_cases, fn({{player_ids, player_city_amount, player_plants}, expected_player_order}) ->
      players =
        player_ids
        |> Enum.zip(player_plants)
        |> Enum.map(fn({player_id, player_plants}) -> {player_id, %{plants: player_plants}} end)
        |> Enum.into(%{})

      board_cities =
        player_ids
        |> Enum.zip(player_city_amount)
        |> Enum.into(%{})
        |> setup_cities

      assert Board.reorder_players(players, board_cities) == expected_player_order
    end
  end

  test "count player cities" do
    for _n <- 1..1000 do
      player_number = Enum.random 3..6
      player_ids = Enum.take_random 1..42, player_number
      initial_setup =
        player_ids
        |> Enum.map(&({&1, Enum.random 0..17}))
        |> Enum.into(%{})

      board_cities = setup_cities(initial_setup)
      assert initial_setup == Board.player_city_amount(player_ids, board_cities)
    end
  end

  test "check if any resouces exceed limit" do
    test_cases = [
      # {resources, plants, expected_result}
      {[0, 3, 0, 0], [3], false},
      {[0, 1, 0, 0], [4], true}
    ]

    Enum.each test_cases, fn({resource_list, plants, expected_result}) ->
      resources =
        [:coal, :oil, :garbage, :uranium]
        |> Enum.zip(resource_list)
        |> Enum.into(%{})

      assert (expected_result == Board.resource_exceed_limit?(resources, plants)),
        "\nresources: #{inspect resources}\nplants: #{inspect plants}\nexpected: #{expected_result}\n"
    end
  end

  defp setup_cities(player_city_amount) do
    Enum.reduce player_city_amount, %{"boom" => []}, fn({player_id, city_amount}, acc) ->
      if city_amount > 0 do
        Enum.reduce 1..city_amount, acc, fn(number, acc) ->
          Map.update acc, :"meow #{number}", [player_id], &(&1 ++ [player_id])
        end
      else
        acc
      end
    end
  end
end
