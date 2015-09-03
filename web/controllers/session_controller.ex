defmodule Tracker.SessionController do
  use Tracker.Web, :controller

  alias Tracker.User

  plug :scrub_params, "user" when action in [:create, :token]

  def new(conn, _params) do
    render(conn, Tracker.SessionView, "new.html")
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

  # jQuery.post('/api/v1/token', {"user[email]": "oscarduignan@gmail.com", "user[password]": "test"}, function(data, status, xhr) { console.log(data, status, xhr); }, 'json');
  def token(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case User.authenticate(email, password) do
      {:ok, user} ->
        authenticated_conn = Guardian.Plug.sign_in(conn, user, :token)
        render(authenticated_conn, user: user, token: Guardian.Plug.current_token(authenticated_conn))
      {:error, _} -> conn
    end
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: "/")
  end
end