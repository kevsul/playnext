defmodule PlaynextWeb.ImportSteamController do
  use PlaynextWeb, :controller

  def index(conn, _params) do
    {:ok, num_imported} = Playnext.Importers.Steam.import()
    render(conn, "index.html", count: num_imported)
  end
end
