defmodule ElixirMonitoringPromWeb.PageController do
  use ElixirMonitoringPromWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
