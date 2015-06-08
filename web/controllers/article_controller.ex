defmodule ElixirExtract.ArticleController do
  use ElixirExtract.Web, :controller
  alias ElixirExtract.Article

  plug :action
  plug :scrub_params, "article" when action in [:create, :update]

  def index(conn, _params) do
    articles = Repo.all(Article)
    render conn, articles: articles
  end

  def show(conn, %{"id" => id}) do
    try do
      article = Repo.get!(Article, id)
      json conn, article
    rescue
      _e in Ecto.NoResultsError ->
        conn |> put_status(:not_found) # 404
      _e in Ecto.CastError ->
        # when id can't convert to integer
        conn |> put_status(400)
    end
  end

  def create(conn, %{"article" => article_params}) do
    changeset = Article.changeset(%Article{}, article_params)

    if changeset.valid? do
      article = Repo.insert(changeset)
      json conn, article
    else
      json (conn |> put_status(422)), %{errors: changeset}
    end
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    try do
      article = Repo.get!(Article, id)
      changeset = Article.changeset(article, article_params)

      if changeset.valid? do
        article = Repo.update(changeset)
        json conn, article
      else
        json (conn |> put_status(422)), %{errors: changeset}
      end
    rescue
      _e in Ecto.NoResultsError ->
        conn |> put_status(:not_found) # 404
      _e in Ecto.CastError ->
        # when id can't convert to integer
        conn |> put_status(400)
    end
  end

end
