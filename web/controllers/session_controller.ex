defmodule Tracker.SessionController do
  use Tracker.Web, :controller

  alias Tracker.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case User.authenticate(email, password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user, :token)
        |> put_flash(:info, "Logged in.")
        |> redirect(to: user_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:info, "Incorrect email or password.")
        |> render("new.html")
    end
  end

  def delete(conn, params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: "/")
  end
end