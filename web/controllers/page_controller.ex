defmodule XmartThingsDemo.PageController do
  use XmartThingsDemo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
