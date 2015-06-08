defmodule ElixirExtract.Case do
  use ExUnit.CaseTemplate

  setup do
    Ecto.Adapters.SQL.restart_test_transaction(ElixirExtract.Repo)
    :ok
  end

  using do
    quote do
      alias ElixirExtract.Article
      alias ElixirExtract.Repo
      use Plug.Test
      import Ecto.Query

      def send_request(conn) do
        conn
        |> put_private(:plug_skip_csrf_protection, true)
        |> ElixirExtract.Endpoint.call([])
      end
    end
  end

end


ExUnit.start

# Create the database, run migrations, and start the test transaction.
Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(ElixirExtract.Repo)