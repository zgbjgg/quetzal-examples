defmodule AppWeb.StateLiveView do
  use Quetzal.LiveView,
    handler: __MODULE__,
    callbacks: [:update_output_div_and_pie_graph]

  @impl Quetzal.LiveView
  def components(_session) do
    {"MYAPP", [{Quetzal.Form, [id: "myform", name: "myform",
       children: [{Quetzal.InputText, [id: "mytext", value: "", name: "mytext"]}]
     ]},
     {Quetzal.Div, [id: "mydiv", style: "", children: ""]},
     {Quetzal.Div, [id: "mydiv2", style: "", children: "In the IEX console execute: AppWeb.StateLiveView.push_update and if the first input contains 'hello' the pie graph will be updated"]},
     {Quetzal.Graph, [id: "mypieg"], [type: "pie", labels: ["Red", "Blue"], values: [10, 20]]}]}
  end

  def push_update() do
    # get state so we can update only when params are "hello" in mytext input
    matches = state("MYAPP")
    |> Enum.filter(fn {_pid, {"myform", params}} ->
           params |> Map.get("mytext") == "hello"
         {_pid, nil} ->
           false
    end)

    # if some matches then update that processes using `update_components/3`, passing
    # as a third parameter the list of pids to update ;-)
    case matches do
      [] -> :ok
      [{pid, _}] ->
        newvalues = for _n <- 1..3, do: :rand.uniform(100)
        components = [mypieg: [labels: ["Black", "White", "Gray"], values: newvalues]]
        update_components("MYAPP", components, [pid])
        :ok
    end
  end

  def update_output_div_and_pie_graph("myform", _target, fields) do
    # This updates the div and the pie graph at the same time
    value = fields["mytext"]
    newvalues = for _n <- 1..3, do: :rand.uniform(100)
    [mydiv: [children: "You've entered #{value} value"],
     mypieg: [labels: ["Black", "White", "Gray"], values: newvalues]]
  end
end
