defmodule Pgboard.PageController do
  use Pgboard.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
