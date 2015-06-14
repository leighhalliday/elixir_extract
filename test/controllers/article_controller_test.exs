defmodule ElixirExtract.ArticleControllerTest do
  use ElixirExtract.Case, async: false

  test "/index returns a list of articles" do
    articles_as_json = create_article
      |> List.wrap
      |> Poison.encode!

    response = conn(:get, "/api/articles") |> send_request

    assert response.status == 200
    assert response.resp_body == articles_as_json
  end

  test "/show returns an article" do
    article = create_article

    article_as_json = Poison.encode!(article)

    response = conn(:get, "/api/articles/#{article.id}") |> send_request

    assert response.status == 200
    assert response.resp_body == article_as_json
  end

  test "/show when article not found" do
    response = conn(:get, "/api/articles/123") |> send_request
    assert response.status == 404
  end

  test "/show when bad request" do
    response = conn(:get, "/api/articles/nope") |> send_request
    assert response.status == 400
  end

  test "/create with valid data" do
    post_data = %{article:
      %{title: "Better article", body: "Better body"}
    }
    response = conn(:post, "/api/articles", post_data) |> send_authenticated_request(find_or_create_user)

    # find last inserted article
    query = from a in Article,
      order_by: [desc: a.id],
      limit: 1
    article = Repo.one!(query)

    assert response.status == 200
    assert response.resp_body == Poison.encode!(article)
  end

  test "/create with invalid data" do
    post_data = %{article:
      %{title: String.duplicate("A", 200), body: ""}
    }

    response = conn(:post, "/api/articles", post_data) |> send_authenticated_request(find_or_create_user)

    assert response.status == 422
    assert response.resp_body == Poison.encode!(%{errors: %{
      title: ["should be at most 140 characters"],
      body: ["can't be blank"]
    }})
  end

  test "/update with valid data" do
    article = create_article

    post_data = %{article:
      %{title: "Updated title"}
    }

    response = conn(:patch, "/api/articles/#{article.id}", post_data) |> send_authenticated_request(find_or_create_user)

    assert response.status == 200
    assert response.resp_body == Poison.encode!(%Article{article | title: "Updated title"})
  end

  test "/update article not found" do
    response = conn(:patch, "/api/articles/123", %{article: %{}}) |> send_authenticated_request(find_or_create_user)
    assert response.status == 404
  end

  test "/update when bad request" do
    response = conn(:patch, "/api/articles/nope", %{article: %{}}) |> send_authenticated_request(find_or_create_user)
    assert response.status == 400
  end

  test "/update with invalid data" do
    article = create_article

    post_data = %{article:
      %{title: String.duplicate("A", 200), body: ""}
    }

    response = conn(:patch, "/api/articles/#{article.id}", post_data) |> send_authenticated_request(find_or_create_user)

    assert response.status == 422
    assert response.resp_body == Poison.encode!(%{errors: %{
      title: ["should be at most 140 characters"],
      body: ["can't be blank"]
    }})
  end

  defp create_article do
    %User{id: user_id} = find_or_create_user
    %Article{title: "Good article", body: "Article body", user_id: user_id}
      |> Repo.insert
  end

end
