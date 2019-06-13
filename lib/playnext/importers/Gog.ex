alias Playnext.Importers.Common
alias Playnext.Game
alias Playnext.Repo

require Logger

defmodule Playnext.Importers.Gog do
  @owned_games_url "https://www.gog.com/u/kevsul/games/stats?sort=recent_playtime&order=desc&page=1"
  @appdetails_url "http://api.gog.com/products"

  def import() do
    get_games()
    |> Enum.take(10)
    |> process_games()
  end

  def get_games() do
    game_list = Common.get_json(@owned_games_url)
    game_list["_embedded"]["items"]
  end

  def process_games(games) do
    games
    |> Enum.filter(&is_new(&1))
    |> Task.async_stream(__MODULE__, :get_game_details, [])
    |> Enum.each(fn {:ok, game} -> save_game(game) end)

    {:ok, Enum.count(games)}
  end

  def is_new(%{"game" => game}) do
    !Repo.get_by(Game, name: game["title"])
  end

  def get_game_details(%{"game" => game}) do
    url = "#{@appdetails_url}/#{game["id"]}?expand=description"
    Logger.debug("Getting url " <> url)
    Common.get_json(url)
  end

  def save_game(game_details) do
    # Check if there's a game of that name already in the DB
    if !Repo.get_by(Game, name: game_details["title"]) do
      Logger.info("Adding new game #{game_details["title"]}")

      Repo.insert!(%Game{
        name: game_details["title"],
        description: game_details["description"]["lead"],
        store_id: game_details["id"],
        image: game_details["images"]["logo"],
        store: "GOG"
        # release_date: game_details["release_date"]["date"]
      })
    end

    # Add platforms
    game_details["content_system_compatibility"]
    |> Enum.filter(fn {_key, value} -> value end)
    |> Enum.map(fn {key, value} -> if key == "osx", do: {"mac", value}, else: {key, value} end)
    |> Enum.each(fn {key, _value} -> Game.add_platform(game_details["title"], key) end)
  end
end
