defmodule ElixirExtract.Repo.Migrations.AddUserIdToArticles do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :user_id, :integer
      add :website_url
      add :website_host
    end
  end
end
