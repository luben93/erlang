defmodule KV do
	use Application

  def start(_type, _args) do
  	KV.Client.Supervisor
    KV.Supervisor.start_link
  end
end

