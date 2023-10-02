defmodule CarpoolWeb.PageLive.Index do
  use CarpoolWeb, :live_view
  alias Carpool.Accounts

  def mount(_params, session, socket) do
    user_signed_in =
      if is_nil(session["user_token"]) do
        false
      else
        true
      end

    current_user =
      if user_signed_in do
        Accounts.get_user_by_session_token(session["user_token"])
      end

    {:ok,
     socket
     |> assign(:user_signed_in, user_signed_in)
     |> assign(:current_user, current_user)}
  end
end
