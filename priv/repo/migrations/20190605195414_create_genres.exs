defmodule Playnext.Repo.Migrations.CreateGenres do
  use Ecto.Migration

  def change do
    create table(:genres) do
      add :name, :string

      timestamps()
    end

    create table(:games_genres) do
      add :game_id, references(:games)
      add :genre_id, references(:genres)
    end
  end
end
