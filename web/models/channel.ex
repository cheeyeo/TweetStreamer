defmodule TwitterPlayground.Channel do
  use TwitterPlayground.Web, :model

  schema "channels" do
    field :name, :string
    has_many :tweets, TwitterPlayground.Tweet
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
