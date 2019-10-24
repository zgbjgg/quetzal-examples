defmodule AppWeb.NestedComponentsLiveView do
  use Quetzal.LiveView,
    handler: __MODULE__,
    callbacks: [:update_output_div_and_pie_graph]

  @impl Quetzal.LiveView
  def components(_session) do
    {"MYAPP", [{Quetzal.Form, [id: "myform", name: "myform", change: "myform",
       children: [{Quetzal.InputText, [id: "mytext", value: "", name: "mytext", change: "mytext"]},
         {Quetzal.InputText, [id: "mytext2", value: "", name: "mytext2", change: "mytext2"]}]
     ]},
     {Quetzal.Div, [id: "mydiv", style: "", children: ""]},
     {Quetzal.Div, [id: "mydiv2", style: "", children: "If you write inside the inputs above the pie graph and div output will change."]},
     {Quetzal.Div, [id: "mydivwithchildren", children: [
       {Quetzal.Graph, [id: "mypieg"], [type: "pie", labels: ["Red", "Blue"], values: [10, 20]]}]
     ]}]}
  end

  def do_update() do
    newvalues = for _n <- 1..3, do: :rand.uniform(100)
    components = [mypieg: [labels: ["Black", "White", "Gray"], values: newvalues]]
    update_components("MYAPP", components)
    :ok
  end

  def update_output_div_and_pie_graph("myform", _target, fields) do
    # This updates the div and the pie graph at the same time
    value = fields["mytext"]
    value2 = fields["mytext2"]
    newvalues = for _n <- 1..3, do: :rand.uniform(100)
    [mydiv: [children: "You've entered #{value} value in the first input and #{value2} in the second one"],
     mypieg: [labels: ["Black", "White", "Gray"], values: newvalues]]
  end
end
