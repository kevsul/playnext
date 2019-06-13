alias Playnext.Importers.Common
alias Playnext.Game
alias Playnext.Repo

require Logger

defmodule Playnext.Importers.Steam do
  @owned_games_url "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=AC66F4F75BB59FCDB2578455194D5DDE&steamid=76561198020386735&format=json"
  @appdetails_url "https://store.steampowered.com/api/appdetails?appids="

  def import() do
    get_games()
    |> Enum.take(25)
    |> process_games()
  end

  def get_json_from_file(filename) do
    {:ok, body} = File.read(filename)
    Poison.decode!(body)
  end

  def get_games() do
    # game_list = Common.get_json(@owned_games_url)
    game_list = get_json_from_file("./steam_games.json")
    game_list["response"]["games"]
  end

  def process_games(games) do
    games
    |> Enum.filter(&is_new(&1))
    |> Task.async_stream(__MODULE__, :get_game_details, [])
    |> Enum.each(fn {:ok, game} -> save_game(game) end)

    {:ok, Enum.count(games)}
  end

  def is_new(game) do
    !Repo.get_by(Game, steam_appid: game["appid"])
  end

  def get_game_details(game) do
    appid = to_string(game["appid"])
    url = "#{@appdetails_url}#{appid}"
    Logger.debug("Getting url " <> url)

    result = Common.get_json(url)
    result[appid]["data"]
  end

  def save_game(nil) do
  end

  def save_game(game_details) do
    # Check if there's a game of that name already in the DB
    if !Repo.get_by(Game, name: game_details["name"]) do
      Logger.info("Adding new game #{game_details["name"]}")

      Repo.insert!(%Game{
        name: game_details["name"],
        description: game_details["short_description"],
        steam_appid: game_details["steam_appid"],
        store_id: game_details["steam_appid"],
        image: game_details["header_image"],
        store: "Steam"
        # release_date: game_details["release_date"]["date"]
      })
    end

    # Add genres
    Enum.each(game_details["genres"], fn genre ->
      Game.add_genre(game_details["name"], genre["description"])
    end)

    # Add platforms
    game_details["platforms"]
    |> Enum.filter(fn {_key, value} -> value end)
    |> Enum.each(fn {key, _value} -> Game.add_platform(game_details["name"], key) end)
  end
end
