defmodule AppWeb.ComponentsLiveView do
  use Quetzal.LiveView

  @impl Quetzal.LiveView
  def components(_session) do
    [{Quetzal.Form, [id: "myform", name: "myform",
       children: [{Quetzal.InputText, [id: "mytext", value: "I'am a text input rendered from Quetzal", name: "mytext"]}]
     ]},
     {Quetzal.Graph, [id: "mypie"], [type: "pie", labels: ["Red", "Blue"], values: [10, 20]]}]
  end
end
