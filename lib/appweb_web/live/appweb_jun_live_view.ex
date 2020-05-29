defmodule AppWeb.JunLiveView do
  use Quetzal.LiveView,
    handler: __MODULE__,
    callbacks: [:update_output_pie_graph]

  @impl Quetzal.LiveView
  def components(_session) do
    # build the options and the first dataframe from CSV
    {options, dataframe} = setup_data()

    # group data by type and extract labels and values
    {labels, values} = group_by_type(dataframe)

    {"MYAPP", [{Quetzal.Form, [id: "myform", name: "myform", change: "myform",
       children: [{Quetzal.Select, [id: "mytext", children: options, name: "myselect"]}]
     ]},
     {Quetzal.Div, [id: "mydiv2", style: "", children: "In the IEX console execute:  AppWeb.JunLiveView.add_row(\"dog\", \"your color here\") and the pie will change with only the filter applied."]},
     {Quetzal.Graph, [id: "mypieg"], [type: "pie", labels: labels, values: values]}]}
  end

  # add a new row to the existing dataframe and update the pie graph
  def add_row(type, color) do
    {:ok, worker} = GenServer.call(AppWeb.Jun, :request_worker)
    {:ok, dataframe} = GenServer.call(AppWeb.Jun, :get_dataframe)
    {:ok, {_, row}} = :jun_pandas.read_string(worker, "type,color\n#{type},#{color}\n", []) 
    {:ok, {_, new_dataframe}} = :jun_pandas.append(worker, dataframe, row, [{"sort", false}, {"ignore_index", true}])
    {labels, values} = group_by_type(new_dataframe)
    :ok = GenServer.call(AppWeb.Jun, {:put_dataframe, new_dataframe})
    :ok = state("MYAPP")
    |> Enum.each(fn {pid, _} ->
         components = [mypieg: [labels: labels, values: values]]
         update_components("MYAPP", components, [pid])
    end)
  end

  # our callback to listen the select
  def update_output_pie_graph("myform", _target, fields) do
    # This updates the div and the pie graph at the same time
    value = fields["myselect"]
    {:ok, dataframe} = GenServer.call(AppWeb.Jun, :get_dataframe)
    {labels, values} = group_by_type(dataframe, value) 
    [mypieg: [labels: labels, values: values]]
  end

  # setup the initial data
  defp setup_data() do
    {:ok, worker} = GenServer.call(AppWeb.Jun, :request_worker)

    {:ok, {_, dataframe}} = :jun_pandas.read_csv(worker, "/Users/zgbjgg/pets.csv", [])
    {:ok, types} = :jun_pandas.unique(worker, dataframe, "type", [])

    :ok = GenServer.call(AppWeb.Jun, {:put_dataframe, dataframe})

    # build options for the selector
    options = types
    |> String.split(",")
    |> Enum.map(fn type ->
         "<option>#{type}</option>"
    end)
    |> Enum.join("")

    {options, dataframe}
  end

  # group data
  defp group_by_type(dataframe, filter \\ nil) do
    {:ok, worker} = GenServer.call(AppWeb.Jun, :request_worker)
    dataframe = case filter do
      nil -> dataframe
      _   ->
        {:ok, {_, qdataframe}} = :jun_pandas.legacy_query(worker, dataframe, "type == #{filter}", [])
        qdataframe
    end
    {:ok, {_, group}} = :jun_pandas.groupby(worker, dataframe, "type", [{"as_index", false}])
    {:ok, {_, grouped_dataframe}} = :jun_pandas.count(worker, group, "color", [])
    {:ok, json_tag} = :jun_pandas.to_json(worker, grouped_dataframe, [])
    data = Jason.decode!(json_tag)
    {data["type"] |> Map.values, data["color"] |> Map.values}
  end
end
