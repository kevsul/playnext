defmodule Playnext.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string

      timestamps()
    end

    create table(:games_tags) do
      add :game_id, references(:games)
      add :tag_id, references(:tags)
      timestamps()
    end
  end
end
