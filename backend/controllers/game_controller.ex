defmodule Pgboard.GameController do
  @moduledoc "render page for both index page and game, while provides initial data for redux"
  use Pgboard.Web, :controller

  def index(conn, _params) do
    # game settings to create a new game
    game_setting = %{
      min_player_amount: 3,
      max_player_amount: 6,
      default_player_amount: 5,
      available_maps: [:Germany, :USA],
      default_map: :Germany
    }

    initial_data = %{
      game_setting: game_setting
    }

    render conn, "index.html", initial_data: Poison.encode!(initial_data)
  end
end
