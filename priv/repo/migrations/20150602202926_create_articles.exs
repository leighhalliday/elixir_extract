defmodule ElixirExtract.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title
      add :body, :text

      timestamps 
    end
  end
end
