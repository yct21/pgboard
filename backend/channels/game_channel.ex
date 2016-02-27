defmodule Pgboard.GameChannel do
  use Pgboard.Web, :channel

  def join("game", _params, socket) do
    {:ok, socket}
  end

  def handle_in("update_state", params, socket) do
    updated_board_state = params["updated_board"]
    :ok = Pgboard.Game.Board.set(updated_board_state)

    broadcast! socket, "updateBoard", %{
      board: updated_board_state
    }

    {:reply, :ok, socket}
  end
end
