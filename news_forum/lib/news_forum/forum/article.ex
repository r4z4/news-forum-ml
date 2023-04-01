defmodule NewsForum.Forum.Article do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "articles" do
    field :attachments, {:array, :binary}
    field :category, :string
    field :content, :string
    field :date, :naive_datetime
    field :desc, :string
    field :title, :string
    field :author, :binary_id

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :category, :desc, :date, :content, :attachments])
    |> validate_required([:title, :category, :desc, :date, :content, :attachments])
  end
end
