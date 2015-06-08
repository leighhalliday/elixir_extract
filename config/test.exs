use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :elixir_extract, ElixirExtract.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :elixir_extract, ElixirExtract.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "lhalliday",
  password: "",
  database: "elixir_extract_test",
  size: 1 # Use a single connection for transactional tests
