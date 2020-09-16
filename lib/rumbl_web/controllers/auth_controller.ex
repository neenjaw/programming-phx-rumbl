defmodule RumblWeb.AuthController do
  import Plug.Conn

  # Plug Functions

  def init(opts), do: opts

  # Get the user id from the conn session params
  # if it isn't false or nil, check if the user exists in the repo
  # assign the user or false to the conn params
  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Rumbl.Accounts.get_user(user_id)
    assign(conn, :current_user, user)
  end

  # Controller Functions

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    # Prevents session fixation attacks
    |> configure_session(renew: true)
  end

  def logout(conn) do
    # If you needed to keep the session data, you could also `delete_session(conn, :user_id)`
    configure_session(conn, drop: true)
  end
end
