defmodule ElixirExtract.User do
  use ElixirExtract.Web, :model

  schema "users" do
    field :name
    field :github_url
    field :github_id
    field :github_token
    field :blog_url

    has_many :articles, ElixirExtract.Article

    timestamps
  end

  @required_fields ~w(name github_url github_id)
  @optional_fields ~w(github_token blog_url)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ nil) do
    model
      |> cast(params, @required_fields, @optional_fields)
  end
end
