alias Playnext.Game
alias Playnext.Repo

defmodule PlaynextWeb.GameController do
  use PlaynextWeb, :controller

  def get(conn, %{"id" => id}) do
    game =
      Repo.get_by!(Game, id: id)
      |> Repo.preload(:genres)
      |> Repo.preload(:platforms)
      |> Repo.preload(:tags)

    render(conn, "show.json", data: game)
  end

  def get_all(conn, _params) do
    games =
      Repo.all(Game)
      |> Enum.map(&Repo.preload(&1, :genres))
      |> Enum.map(&Repo.preload(&1, :platforms))
      |> Enum.map(&Repo.preload(&1, :tags))

    render(conn, "show.json", data: games)
  end
end
