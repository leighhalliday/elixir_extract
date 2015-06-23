defmodule ElixirExtract.Article do
  use Ecto.Model

  schema "articles" do
    field :title
    field :body
    #field :user_id, :integer
    field :website_url
    field :website_host

    belongs_to :user, ElixirExtract.User

    timestamps
  end

  @required_fields ~w(title body user_id)
  @optional_fields ~w(website_url website_host)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ nil) do

    model
      |> cast(params, @required_fields, @optional_fields)
      |> validate_length(:title, max: 140)
      |> validate_length(:body, max: 1000)
  end

  def get_with_user!(id) do
    query = from a in ElixirExtract.Article,
      preload: [:user],
      where: a.id == ^id
    ElixirExtract.Repo.one!(query)
  end
end
