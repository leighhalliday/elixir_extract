defmodule ElixirExtract.ArticleView do
  use ElixirExtract.Web, :view

  def render("index.json", %{articles: articles}) do
    articles
  end

  def render("show.json", %{article: article}) do
    article
  end
end
