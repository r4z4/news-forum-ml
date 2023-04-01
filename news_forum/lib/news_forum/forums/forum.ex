defmodule NewsForum.Forums.Forum do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "forums" do
    field :articles, {:array, :binary}
    field :category, :string
    field :desc, :string
    field :members, {:array, :binary}
    field :title, :string
    field :moderator, :binary_id

    timestamps()
  end

  @doc false
  def changeset(forum, attrs) do
    forum
    |> cast(attrs, [:title, :category, :desc, :members, :articles])
    |> validate_required([:title, :category, :desc, :members, :articles])
  end
end
