defmodule XmartThingsDemo.PageController do
  use XmartThingsDemo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def lock(conn, %{"cmd" => cmd}) do
    result = cmd
      |> handle_lock(get_session(conn, :st_token), get_session(conn, :st_uri))
      |> parse_response
    conn
    |> render(XmartThingsDemo.PageView, "lock.json", resp: result)
  end

  def lock(conn, _params) do
    result = "list"
      |> handle_lock(get_session(conn, :st_token), get_session(conn, :st_uri))
      |> parse_response

    render conn, "lock.html",
      locks: result
  end

  defp handle_lock(cmd, token, uri) when is_binary(token) do
    header = [{"authorization", "Bearer #{token}"}]
    case cmd do
      "list" ->
        HTTPoison.get(uri <> "/locks", header)
      "on" ->
        HTTPoison.put(uri <> "/locks/on", "", header)
      "off" ->
        HTTPoison.put(uri <> "/locks/off", "", header)
      _ ->
        {:error, "The command was not recognized by the system."}
    end
  end
  defp handle_lock(_, _, _), do: {:error, "You are not authorized to access SmartThings!"}

  defp parse_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 204}} -> %{success: true, msg: "operation successful"}
      {:ok, %HTTPoison.Response{body: body}} -> body |> Poison.decode!
      {:error, msg} when is_binary(msg) -> msg
      _ -> "Unknown error occurred"
    end
  end
end
