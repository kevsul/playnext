defmodule PlaynextWeb.GenreView do
  use PlaynextWeb, :view
  @attributes [:id, :name]

  def render("show.json", %{data: genres}) when is_list(genres) do
    for genre <- genres do
      render("show.json", data: genre)
    end
  end

  def render("show.json", %{data: genre}) do
    genre
    |> Map.take(@attributes)
  end
end
