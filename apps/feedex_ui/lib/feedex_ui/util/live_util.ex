defmodule FeedexUi.LiveUtil do
  @moduledoc """
  Conveniences for use within LiveViews.
  """

  @doc """
  Returns the user for a session that contains a user token.
  """
  def user_from_session(session) do
    session["user_token"]
    |> FeedexData.Accounts.get_user_by_session_token()
  end
end
