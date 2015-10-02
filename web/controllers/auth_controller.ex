defmodule ElixirExtract.AuthController do
  use ElixirExtract.Web, :controller
  alias ElixirExtract.GitHubUser

  def github(conn, %{"code" => code}) do
    # get token from gethub given a code
    token = GitHub.get_token!(code: code)

    # connect to github using token
    github_user = OAuth2.AccessToken.get!(token, "/user")

    # create user in our system based on github info
    user = GitHubUser.create_or_update(github_user, token.access_token)

    # respond with token and user info
    json conn, %{token: token.access_token, user: user}
  end

end
