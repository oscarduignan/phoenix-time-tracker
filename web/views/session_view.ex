defmodule Tracker.SessionView do
  use Tracker.Web, :view

  def render("token.json", %{user: user, token: token}) do
    %{user_id: user.id, token: token}
  end
end
