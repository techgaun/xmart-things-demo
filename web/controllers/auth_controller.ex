defmodule XmartThingsDemo.AuthController do
  @moduledoc """
  A module that handles callback and other things while talking with OAuth
  """

  use XmartThingsDemo.Web, :controller
  require Logger

  def index(conn, %{"provider" => "smartthings"}) do
    redirect conn, external: XmartThings.authorize_url!
  end
  def index(conn, _), do: not_found(conn)

  def callback(conn, %{"code" => code}) do
    st_client = XmartThings.get_token!(code: code)
    [%{"uri" => uri} | _] = XmartThings.endpoints!(st_client).body
    conn
    |> fetch_session
    |> put_session(:st_token, st_client.token.access_token)
    |> put_session(:st_uri, uri)
    |> redirect(to: "/locks")
  end
  def callback(conn, params) do
    Logger.debug inspect params
    conn
    |> not_found
  end

  defp not_found(conn) do
    conn
    |> put_status(:not_found)
    |> render(XmartThingsDemo.ErrorView, "404.json")
    |> halt
  end
end
