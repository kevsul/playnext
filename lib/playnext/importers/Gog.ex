defmodule Playnext.Importers.Gog do
  @owned_games_url "https://www.gog.com/u/kevsul/games/stats?sort=recent_playtime&order=desc&page=1"
  @appdetails_url "http://api.gog.com/products"

  def import() do
    get_games()
    |> Enum.take(5)
    |> process_games()
  end

  def get_games() do
    game_list = Playnext.Importers.Common.get_json(@owned_games_url)
    game_list["_embedded"]["items"]
  end

  def process_games(games) do
    games
    |> Enum.filter(&is_new(&1))
    |> Task.async_stream(Playnext.Importers.Gog, :get_game_details, [])
    |> Enum.each(fn {:ok, game} -> save_game(game) end)

    {:ok, Enum.count(games)}
  end

  def is_new(%{"game" => game}) do
    IO.inspect(game)
    !Playnext.Repo.get_by(Playnext.Game, name: game["title"])
  end

  def get_game_details(%{"game" => game}) do
    url = "#{@appdetails_url}/#{game["id"]}?expand=description"
    IO.puts("Getting url " <> url)
    Playnext.Importers.Common.get_json(url)
  end

  def save_game(data) do
    IO.inspect(data)
    # Check if there's a game of that name already in the DB
    if Playnext.Repo.get_by(Playnext.Game, name: data["title"]) do
      # TODO Update existing game with new store details
    else
      game_db = %Playnext.Game{
        name: data["title"],
        description: data["description"]["lead"],
        store_id: data["id"],
        image: data["images"]["logo"],
        store: "GOG"
        # release_date: data["release_date"]["date"]
      }

      Playnext.Repo.insert(game_db)
    end
  end
end
