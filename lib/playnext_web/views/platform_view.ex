defmodule PlaynextWeb.PlatformView do
  use PlaynextWeb, :view
  @attributes [:id, :name]

  def render("show.json", %{data: platforms}) when is_list(platforms) do
    for platform <- platforms do
      render("show.json", data: platform)
    end
  end

  def render("show.json", %{data: platform}) do
    platform
    |> Map.take(@attributes)
  end
end
