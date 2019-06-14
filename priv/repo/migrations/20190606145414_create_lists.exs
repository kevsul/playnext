defmodule Playnext.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add(:name, :string)
      add(:items, {:array, :integer}, default: [])

      timestamps()
    end
  end
end
