defmodule ElixirExtract.GitHubUser do

  alias ElixirExtract.User
  alias ElixirExtract.Repo
  import Ecto.Query

  def create_or_update(gh_params, access_token) do
    user = Repo.get_by(User, github_id: Integer.to_string(gh_params["id"]))
    save(user, gh_params, access_token)
  end

  def save(nil, gh_params, access_token) do
    user_params(gh_params, access_token) |> Repo.insert
  end

  def save(user, gh_params, access_token) do
    # changeset expects a Map not a Struct
    user_map = user_params(gh_params, access_token) |> Map.from_struct
    User.changeset(user, user_map) |> Repo.update
  end

  def user_params(gh_params, access_token) do
    %User{
      name: gh_params["name"],
      github_id: Integer.to_string(gh_params["id"]),
      github_url: gh_params["html_url"],
      github_token: access_token,
      blog_url: gh_params["blog"]
    }
  end

end