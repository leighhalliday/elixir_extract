defmodule ElixirExtract.Case do
  use ExUnit.CaseTemplate

  setup do
    Ecto.Adapters.SQL.restart_test_transaction(ElixirExtract.Repo)
    :ok
  end

  using do
    quote do
      alias ElixirExtract.Article
      alias ElixirExtract.User
      alias ElixirExtract.Repo
      use Plug.Test
      import Ecto.Query

      def send_request(conn) do
        conn
        |> put_private(:plug_skip_csrf_protection, true)
        |> ElixirExtract.Endpoint.call([])
      end

      def send_authenticated_request(conn, %User{github_token: token}) do
        conn
        |> add_req_header("authorization", token)
        |> send_request
      end

      defp add_req_header(%Plug.Conn{req_headers: headers} = conn, key, value) do
        %{conn | req_headers: List.keystore(headers, key, 0, {key, value})}
      end

      defp find_or_create_user do
        try do
          Repo.get_by!(User, github_token: "ABCD12345")
        rescue
          _e in Ecto.NoResultsError ->
            %User{name: "Leigh Halliday", github_url: "http://www.github.com",
              github_id: "12345", github_token: "ABCD12345"
            }
            |> Repo.insert
        end
      end

    end
  end

end


ExUnit.start

# Create the database, run migrations, and start the test transaction.
Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(ElixirExtract.Repo)