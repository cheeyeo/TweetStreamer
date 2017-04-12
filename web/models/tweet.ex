defmodule TwitterPlayground.Tweet do
  use TwitterPlayground.Web, :model

  schema "tweets" do
    field :username, :string
    field :text, :string
    field :id_str, :string
    field :profile_image_url_https, :string
    field :image_url, :string
    field :source_url, :string
    field :created_at, Ecto.DateTime
    belongs_to :channel, TwitterPlayground.Channel
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :text, :id_str, :created_at])
    |> validate_required([:username, :text, :id_str, :created_at])
  end
end
