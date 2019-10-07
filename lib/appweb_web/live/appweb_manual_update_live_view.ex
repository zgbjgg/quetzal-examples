defmodule AppWeb.ManualUpdateLiveView do
  use Quetzal.LiveView

  @impl Quetzal.LiveView
  def components(_session) do
    [{Quetzal.Div, [id: "mydiv", style: "", children: "In the IEX console execute the next: AppWeb.ManualUpdateLiveView.trigger_update and every 5ms the pie graph will be updated"]},
     {Quetzal.Graph, [id: "mypie"], [type: "pie", labels: ["Black", "White", "Gray"], values: [10, 20, 30]]}]
  end

  def trigger_update() do
    :timer.sleep(5000)
    white = :rand.uniform(100)
    black = :rand.uniform(100)
    gray = :rand.uniform(100)
    components = [mypie: [labels: ["Black", "White", "Gray"], values: [black, white, gray]]]
    update_components(components)
    trigger_update()
  end
end
