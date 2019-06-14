defmodule PlaynextWeb.TagView do
  use PlaynextWeb, :view
  @attributes [:id, :name]

  def render("show.json", %{data: tags}) when is_list(tags) do
    for tag <- tags do
      render("show.json", data: tag)
    end
  end

  def render("show.json", %{data: tag}) do
    tag
    |> Map.take(@attributes)
  end
end
