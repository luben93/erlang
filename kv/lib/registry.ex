defmodule KV.Registry do
  use GenServer

  ## Client API

  @doc """
  Starts the registry with the given `name`.
  """
  def start_link(name) do
    # 1. Pass the name to GenServer's init
    GenServer.start_link(__MODULE__, name, name: name)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, name) when is_atom(server) do
    # 2. Lookup is now done directly in ETS, without accessing the server
    case :ets.lookup(server, name) do
      [{^name, bucket}] -> {:ok, bucket}
      [] -> :error
    end
  end

  @doc """
  Ensures there is a bucket associated to the given `name` in `server`.
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  @doc """
  Stops the registry.
  """
  def stop(server) do
    GenServer.stop(server)
  end

  ## Server callbacks

  def init(table) do
    # 3. We have replaced the names map by the ETS table
    names = :ets.new(table, [:named_table, read_concurrency: true])
    refs  = %{}
    {:ok, {names, refs}}
  end

  # 4. The previous handle_call callback for lookup was removed

  def handle_cast({:create, name}, {names, refs}) do
    # 5. Read and write to the ETS table instead of the map
    case lookup(names, name) do
      {:ok, _pid} ->
        {:noreply, {names, refs}}
      :error ->
        {:ok, pid} = KV.Bucket.Supervisor.start_bucket()
        ref = Process.monitor(pid)
        refs = Map.put(refs, ref, name)
        :ets.insert(names, {name, pid})
        {:noreply, {names, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    # 6. Delete from the ETS table instead of the map
    {name, refs} = Map.pop(refs, ref)
    :ets.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
# defmodule KV.Registry do
#   use GenServer

#   ## Client API

#   # @doc """
#   # Starts the registry.
#   # """
#   # def start_link() do
#   #   GenServer.start_link(__MODULE__, :ok, [])
#   # end

#    @doc """
#   Starts the registry with the given `name`.
#   """
#   def start_link(name) do
#     GenServer.start_link(__MODULE__, :ok, name: name)
#   end

#   @doc """
#   Looks up the bucket pid for `name` stored in `server`.

#   Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
#   """
#   def lookup(server, name) do
#     GenServer.call(server, {:lookup, name})
#   end

#   @doc """
#   Ensures there is a bucket associated to the given `name` in `server`.
#   """
#   def create(server, name) do
#     GenServer.cast(server, {:create, name})
#   end

#   ## Server Callbacks

#   # def init(:ok) do
#   #   {:ok, %{}}
#   # end

#   # def handle_call({:lookup, name}, _from, names) do
#   #   {:reply, Map.fetch(names, name), names}
#   # end

#   # def handle_cast({:create, name}, names) do
#   #   if Map.has_key?(names, name) do
#   #     {:noreply, names}
#   #   else
#   #     {:ok, bucket} = KV.Bucket.start_link()
#   #     {:noreply, Map.put(names, name, bucket)}
#   #   end
#   # end

#    def init(:ok) do
#     names = %{}
#     refs  = %{}
#     {:ok, {names, refs}}
#   end

#   def handle_call({:lookup, name}, _from, {names, _} = state) do
#     {:reply, Map.fetch(names, name), state}
#   end

#   # def handle_cast({:create, name}, {names, refs}) do
#   #   if Map.has_key?(names, name) do
#   #     {:noreply, {names, refs}}
#   #   else
#   #     {:ok, pid} = KV.Bucket.start_link()
#   #     ref = Process.monitor(pid)
#   #     refs = Map.put(refs, ref, name)
#   #     names = Map.put(names, name, pid)
#   #     {:noreply, {names, refs}}
#   #   end
#   # end
#    def handle_cast({:create, name}, {names, refs}) do
#     if Map.has_key?(names, name) do
#       {:noreply, {names, refs}}
#     else
#       {:ok, pid} = KV.Bucket.Supervisor.start_bucket()
#       ref = Process.monitor(pid)
#       refs = Map.put(refs, ref, name)
#       names = Map.put(names, name, pid)
#       {:noreply, {names, refs}}
#     end
#   end

#   def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
#     {name, refs} = Map.pop(refs, ref)
#     names = Map.delete(names, name)
#     {:noreply, {names, refs}}
#   end

#   def handle_info(_msg, state) do
#     {:noreply, state}
#   end
# end