defmodule CarpoolWeb.PageController do
  use CarpoolWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
