defmodule Pgboard.Game.PreparationPhaseTest do
  use ExUnit.Case, async: true

  setup %{player_amount: player_amount} do
    map = :usa
    players = [
      {42, "DolorousMarvin", "Avatar for DolorousMarvin"},
      {24, "Era_Darkstar", "Avatar for Era_Darkstar"},
      {10, "夫子智夫子", "Avatar for 夫子智夫子"},
      {96, "冰雪龙族圣骑士", "Avatar for 冰雪龙族圣骑士"},
      {11, "锦帆游侠—甘", "Avatar for 锦帆游侠—甘"},
      {21, "Kara Thrace", "Avatar for Kara Thrace"}
    ] |> Enum.take(player_amount)

    current_move = %{map: map, current_phase: :preparation, players: players}
    {:ok, board_state, logs_to_append} = Pgboard.Game.Arbiter.handle_move(%{}, current_move)

    {:ok, %{board_state: board_state, logs_to_append: logs_to_append}}
  end

  @tag player_amount: 4
  test "board is initialized properly with 4 players", %{board_state: board_state, logs_to_append: logs_to_append} do
    test_by_player_amount(board_state, logs_to_append, 4)
  end

  defp test_by_player_amount(board_state, _logs_to_append, _player_amount) do
    test_map_module(board_state)
    test_players(board_state)
    test_player_order(board_state)
  end

  defp test_map_module(board_state) do
    assert board_state.map == :usa
    assert board_state.map_module == Pgboard.Game.UsaMap
  end

  defp test_players(board_state) do
    players = board_state.players

    colors = Enum.map players, fn({_player_id, %{color: color}}) -> color end
    assert Enum.uniq(colors) == colors
    Enum.each colors, fn(color) -> assert color in [:purple, :red, :blue, :pink, :orange, :black] end

    # Check players initialized with players in current_move
    Enum.each board_state.current_move.players, fn({player_id, name, avatar}) ->
      player = players[player_id]
      assert player.name == name
      assert player.avatar == avatar
      assert player.plants == []
      assert player.resources == %{coal: 0, oil: 0, garbage: 0, uranium: 0}
    end
  end

  defp test_player_order(%{players: players, player_order: player_order, table_order: table_order}) do
    player_ids = Map.keys players
    assert player_order == table_order
    assert Enum.sort(player_ids) == Enum.sort(player_order)
  end
end
