defmodule ElixirExtract.Authenticator do

  alias ElixirExtract.User
  alias ElixirExtract.Repo
  import Ecto.Query

  def find_user(conn) do
    token = Plug.Conn.get_req_header conn, "authorization"

    try do
      user = Repo.get_by!(User, github_token: List.first(token))
      {:ok, user}
    rescue
      _e in Ecto.NoResultsError ->
        :error
    end
  end

end