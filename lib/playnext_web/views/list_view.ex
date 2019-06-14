defmodule PlaynextWeb.ListView do
  use PlaynextWeb, :view
  @attributes [:id, :name, :items]

  def render("show.json", %{data: data}) do
    data
    |> Map.take(@attributes)
  end
end
