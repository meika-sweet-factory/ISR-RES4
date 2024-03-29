defmodule Api.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :body, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :video_id, references(:videos, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:video_id])
  end
end
