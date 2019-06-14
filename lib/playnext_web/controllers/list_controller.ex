alias Playnext.List
alias Playnext.Repo

defmodule PlaynextWeb.ListController do
  use PlaynextWeb, :controller

  def get(conn, %{"id" => id}) do
    list = Repo.get_by!(List, id: id)
    render(conn, "show.json", data: list)
  end
end
