defmodule NewsForum.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :category, :string
      add :desc, :string
      add :date, :naive_datetime
      add :content, :text
      add :attachments, {:array, :binary}
      add :author, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:articles, [:author])
  end
end
