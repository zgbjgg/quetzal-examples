defmodule AppWebWeb.PageController do
  use AppWebWeb, :controller

  # Use phoenix live view to render in order to use Quetzal
  alias Phoenix.LiveView

  def index(conn, _params) do
    render conn, "index.html"
  end

  def components(conn, _params) do
    LiveView.Controller.live_render(conn, AppWeb.ComponentsLiveView, session: %{})
  end

  def manual_update(conn, _params) do
    LiveView.Controller.live_render(conn, AppWeb.ManualUpdateLiveView, session: %{})
  end

  def callbacks(conn, _params) do
    LiveView.Controller.live_render(conn, AppWeb.CallbacksLiveView, session: %{})
  end

  def multiapp(conn, params) do
    LiveView.Controller.live_render(conn, AppWeb.MultiAppLiveView, session: %{"app" => params["app"]})
  end
end