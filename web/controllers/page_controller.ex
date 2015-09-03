defmodule Tracker.PageController do
  use Tracker.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
