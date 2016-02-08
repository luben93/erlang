defmodule KV do
	use Application

  def start(_type, _args) do
#    c("lib/db.erl")

  	KV.Client.Supervisor
    KV.Supervisor.start_link
  end
end

