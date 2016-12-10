defmodule XmartThingsDemo.PageView do
  use XmartThingsDemo.Web, :view

  def render("lock.json", %{resp: resp}) do
    resp 
  end
end
