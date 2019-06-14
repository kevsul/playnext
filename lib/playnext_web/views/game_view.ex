defmodule PlaynextWeb.GameView do
  use PlaynextWeb, :view
  @attributes [:id, :name, :description]

  def render("show.json", %{data: games}) when is_list(games) do
    for game <- games do
      render("show.json", data: game)
    end
  end

  def render("show.json", %{data: game}) do
    game
    |> Map.take(@attributes)
    |> Map.put(:genres, PlaynextWeb.GenreView.render("show.json", data: game.genres))
    |> Map.put(:platforms, PlaynextWeb.PlatformView.render("show.json", data: game.platforms))
    |> Map.put(:tags, PlaynextWeb.TagView.render("show.json", data: game.tags))
  end
end
