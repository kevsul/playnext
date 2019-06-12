defmodule PlaynextWeb.PageController do
  use PlaynextWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
