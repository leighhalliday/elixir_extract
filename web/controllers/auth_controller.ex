defmodule ElixirExtract.AuthController do
  use ElixirExtract.Web, :controller
  alias ElixirExtract.GitHubUser

  plug :action

  def github(conn, %{"code" => code}) do
    token = GitHub.get_token!(code: code)

    IO.inspect "**********************"
    IO.inspect token

    github_user = OAuth2.AccessToken.get!(token, "/user")

    IO.inspect "**********************"
    IO.inspect github_user

    user = GitHubUser.create_or_update(github_user, token.access_token)

    IO.inspect "**********************"
    IO.inspect user

    json conn, %{token: token.access_token}
  end

end
