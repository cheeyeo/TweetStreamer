defmodule TwitterPlayground.Repo.Migrations.CreateTweet do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :username, :string
      add :text, :text
      add :id_str, :string
      add :created_at, :naive_datetime
      add :channel_id, references(:channels)
      timestamps()
    end

    create index(:tweets, [:channel_id])
  end
end
