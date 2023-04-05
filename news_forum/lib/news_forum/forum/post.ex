defmodule NewsForum.Forum.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :category, :string
    field :content, :string
    field :date, :naive_datetime
    field :title, :string
    field :author, :binary_id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :category, :date, :content])
    |> validate_required([:title, :category, :date, :content])
  end
end
