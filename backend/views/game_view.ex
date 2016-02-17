defmodule Pgboard.GameView do
  use Pgboard.Web, :view

  def prerendered_game_index_data(_conn) do
    %{
      games: [],
      players: [],
      player_info: %{
        player_id: 42,
        player_name: "DolorousMarvin",
        win: 11,
        lose: 25
      }
    }
  end
end
