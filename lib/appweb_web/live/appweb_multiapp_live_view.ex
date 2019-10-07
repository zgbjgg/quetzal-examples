defmodule AppWeb.MultiAppLiveView do
  use Quetzal.LiveView

  @impl Quetzal.LiveView
  def components(session) do
    app = session["app"]
    [{Quetzal.Div, [id: "mydiv", style: "", children: "I am a div in the app: #{app}"]}]
  end
end
