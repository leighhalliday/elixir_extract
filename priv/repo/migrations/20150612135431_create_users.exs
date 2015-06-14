defmodule ElixirExtract.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name
      add :github_url
      add :github_id
      add :github_token
      add :blog_url

      timestamps
    end
  end
end
