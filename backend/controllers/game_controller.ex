defmodule Pgboard.GameController do
  @moduledoc "render page for both index page and game, while provides initial data for redux"
  use Pgboard.Web, :controller

  def index(conn, _params) do
    # game settings to create a new game
    players = []

    initial_data = %{
      board: %{
        players: players
      }
    }

    render conn, "index.html", initial_data: Poison.encode!(initial_data)
  end
end
