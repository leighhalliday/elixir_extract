defmodule ElixirExtract.ArticleView do
  use ElixirExtract.Web, :view

  def render("index.json", %{articles: articles}) do
    render_many(articles, ElixirExtract.ArticleView, "article.json")
  end

  def render("show.json", %{article: article}) do
    render_one(article, ElixirExtract.ArticleView, "article.json")
  end

  def render("article.json", %{article: article}) do
    user = article.user

    %{id: article.id,
      title: article.title,
      body: article.body,
      website_url: article.website_url,
      website_host: article.website_host,
      user: %{
        name: user.name,
        githb_url: user.github_url,
        github_id: user.github_id,
        github_token: user.github_token
      }
    }
  end
end
