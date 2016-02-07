
defmodule KV.Supervisor do
  use Supervisor

  # A simple module attribute that stores the supervisor name
  @name KV.Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end
#
  def start_bucket do
    Supervisor.start_child(@name, [])
  end

  # def init(:ok) do
  #   children = [
  #     worker(KV.Bucket, [], restart: :temporary)
  #   ]

  #   supervise(children, strategy: :simple_one_for_one)
  # end
  def init(:ok) do
    children = [
      worker(KV.Registry, [KV.Registry]),
      supervisor(KV.Client.Supervisor, []),
      supervisor(KV.Bucket.Supervisor, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
