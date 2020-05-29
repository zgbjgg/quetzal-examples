defmodule AppWeb.Jun do
  use GenServer

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_state) do
    case :jun_worker.start_link('python3.6') do
      {:ok, worker} ->
        Logger.debug "started jun generic server at #{inspect worker}"
        {:ok, [worker, nil]}
      error         ->
        Logger.warn "won't start jun generic server, error #{inspect error}"
        {:error, error}
    end
  end

  @impl true
  def terminate(_reason, [worker, _]) do
    :ok = :jun_worker.stop_link(worker)
    :ok
  end

  @impl true
  def handle_call(:request_worker, _from, [worker, dataframe]) do
   {:reply, {:ok, worker}, [worker, dataframe]}
  end

  @impl true
  def handle_call({:put_dataframe, dataframe}, _from, [worker, _]) do
    {:reply, :ok, [worker, dataframe]}
  end

  @impl true
  def handle_call(:get_dataframe, _from, [worker, dataframe]) do
    {:reply, {:ok, dataframe}, [worker, dataframe]}
  end
end
