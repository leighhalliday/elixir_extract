defmodule ElixirExtract.PageController do
  use ElixirExtract.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
