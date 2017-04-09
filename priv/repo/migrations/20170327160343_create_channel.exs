defmodule TwitterPlayground.Repo.Migrations.CreateChannel do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :name, :string
      timestamps()
    end

    create unique_index(:channels, [:name])
  end
end
