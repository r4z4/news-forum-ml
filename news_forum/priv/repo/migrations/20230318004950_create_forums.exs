defmodule NewsForum.Repo.Migrations.CreateForums do
  use Ecto.Migration

  def change do
    create table(:forums, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :category, :string
      add :desc, :string
      add :members, {:array, :binary}
      add :articles, {:array, :binary}
      add :moderator, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:forums, [:moderator])
  end
end
