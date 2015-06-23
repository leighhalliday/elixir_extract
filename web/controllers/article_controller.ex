defmodule ElixirExtract.ArticleController do
  use ElixirExtract.Web, :controller
  alias ElixirExtract.Article
  alias ElixirExtract.User
  alias ElixirExtract.Authenticator

  plug :authenticate when action in [:create, :update]
  plug :find_article when action in [:show, :update]
  plug :scrub_params, "article" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    query = from a in Article,
      order_by: [desc: a.id],
      preload: [:user],
      limit: 10
    articles = Repo.all(query)

    render conn, articles: articles
  end

  def show(%Plug.Conn{assigns: %{article: article}} = conn, _) do
    json conn, article
  end

  def create(conn, %{"article" => article_params}) do
    %Plug.Conn{assigns: %{user: user}} = conn
    %User{id: user_id} = user

    changeset = Article.changeset(%Article{user_id: user_id}, article_params)

    if changeset.valid? do
      article = Repo.insert(changeset)
      json conn, article
    else
      json (conn |> put_status(422)), %{errors: changeset}
    end
  end

  def update(%Plug.Conn{assigns: %{article: article}} = conn, %{"id" => id, "article" => article_params}) do
    changeset = Article.changeset(article, article_params)
    if changeset.valid? do
      article = Repo.update(changeset)
      json conn, article
    else
      json (conn |> put_status(422)), %{errors: changeset}
    end
  end

  defp authenticate(conn, _) do
    case Authenticator.find_user(conn) do
      {:ok, user} ->
        assign(conn, :user, user)
      :error ->
        conn |> put_status(401) |> halt
    end
  end

  defp find_article(%Plug.Conn{params: %{"id" => id}} = conn, _) do
    try do
      article = Article.get_with_user!(id)
      assign(conn, :article, article)
    rescue
      _e in Ecto.NoResultsError ->
        conn |> put_status(:not_found) |> halt # 404
      _e in Ecto.CastError ->
        conn |> put_status(400) |> halt
    end
  end

end
