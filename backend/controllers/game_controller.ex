defmodule Pgboard.GameController do
  @moduledoc "render page for both index page and game, while provides initial data for redux"
  use Pgboard.Web, :controller

  def index(conn, _params) do
    initial_data = %{
      board: %{
        playerOrder: [42],
        tableOrder: [42],
        players: %{
          "42" => %{
            "id" => 42,
            "name" => "胭脂糖6",
            "portrait" => "f7e3e883ade88482e7b39636e829",
            "color" => "red",
            "funds" => 42,
            "cities" => 11,
            "plants" => [11, 42],
            "resources" => %{
              "coal" => 1,
              "oil" => 2,
              "garbage" => 4,
              "uranium" => 8
            }
          }
        }
      }
    }

    render conn, "index.html", initial_data: Poison.encode!(initial_data)
  end
end
