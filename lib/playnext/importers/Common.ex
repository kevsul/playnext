defmodule Playnext.Importers.Common do
  def get_json(url) do
    {:ok, response} = HTTPoison.get(url)
    Poison.decode!(response.body)
  end
end
