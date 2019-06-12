defmodule Playnext.Importers.Steam do
  @owned_games_url "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=AC66F4F75BB59FCDB2578455194D5DDE&steamid=76561198020386735&format=json"
  @appdetails_url "https://store.steampowered.com/api/appdetails?appids="

  def import() do
    get_games()
    |> Enum.take(15)
    |> process_games()
  end

  def get_json_from_file(filename) do
    {:ok, body} = File.read(filename)
    Poison.decode!(body)
  end

  def get_games() do
    # game_list = Playnext.Importers.Common.get_json(@owned_games_url)
    game_list = get_json_from_file("./steam_games.json")
    game_list["response"]["games"]
  end

  def process_games(games) do
    games
    |> Enum.filter(&is_new(&1))
    |> Task.async_stream(Playnext.Importers.Steam, :get_game_details, [])
    |> Enum.each(fn {:ok, game} -> save_game(game) end)

    {:ok, Enum.count(games)}
  end

  def is_new(game) do
    !Playnext.Repo.get_by(Playnext.Game, steam_appid: game["appid"])
  end

  def get_game_details(game) do
    appid = to_string(game["appid"])
    url = "#{@appdetails_url}#{appid}"
    IO.puts("Getting url " <> url)

    result = Playnext.Importers.Common.get_json(url)
    result[appid]["data"]
  end

  def save_game(game_details) do
    # Check if there's a game of that name already in the DB
    if Playnext.Repo.get_by(Playnext.Game, name: game_details["name"]) do
      # TODO Update store details?
    else
      Playnext.Repo.insert!(%Playnext.Game{
        name: game_details["name"],
        description: game_details["short_description"],
        steam_appid: game_details["steam_appid"],
        store_id: game_details["steam_appid"],
        image: game_details["header_image"],
        store: "Steam"
        # release_date: game_details["release_date"]["date"]
      })

      # Add genres
      genre_names =
        Enum.map(game_details["genres"], fn genre ->
          Playnext.Game.add_genre(game_details["name"], genre["description"])
        end)
    end
  end
end
