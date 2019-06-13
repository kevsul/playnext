defmodule Playnext.Repo.Migrations.CreatePlatforms do
  use Ecto.Migration

  def change do
    create table(:platforms) do
      add :name, :string

      timestamps()
    end

    create table(:games_platforms) do
      add :game_id, references(:games)
      add :platform_id, references(:platforms)
    end
  end
end
