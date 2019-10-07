defmodule AppWeb.LiveView do
  use Quetzal.LiveView,
    handler: __MODULE__,
    callbacks: [:update_output_div_and_pie_graph]

  require Logger

  @impl Quetzal.LiveView
  def components(_session) do
    [{Quetzal.Form, [id: "myform", name: "myform",
       children: [{Quetzal.InputText, [id: "mytext", value: "", name: "mytext"]},
         {Quetzal.InputText, [id: "mytext2", value: "", name: "mytext2"]}]
     ]},
     {Quetzal.Div, [id: "mydiv", style: "", children: ""]},
     {Quetzal.Graph, [id: "mypie"], [type: "pie", labels: ["Red", "Blue"], values: [10, 20]]}]
  end

  def update_output_div("myform", _target, [value, _]) do
    # This updates the children of the div
    [mydiv: [children: "You've entered #{value} value in the first input"]]
  end

  def update_output_pie_graph("myform", _target, _value) do
    # This updates a pie chart
    [mypie: [labels: ["Black", "White"], values: [100, 200, 300]]]
  end

  def update_output_div_and_pie_graph("myform", _target, [value, value2]) do
    # This updates the div and the pie graph at the same time
    [mydiv: [children: "You've entered #{value} value in the first input and #{value2} in the second one"],
     mypie: [labels: ["Black", "White", "Gray"], values: [100, 200, 300]]]
  end
end
