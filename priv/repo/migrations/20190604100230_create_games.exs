defmodule Playnext.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :name, :string
      add :description, :text
      add :image, :string
      add :release_date, :date
      add :steam_appid, :integer
      add :store, :string
      add :store_id, :integer

      timestamps()
    end
  end
end
