defmodule Client do
	 def echo([msg]) do
		echo(msg)	
	 end
	 def echo([msg|rest]) do
	 	echo(msg)
	 	echo([rest])
	 end
	 def echo(msg) do
	 	IO.puts(msg)
	 end


	def start do
	    {:ok, pid}=Task.start_link(fn -> loop(:db.new) end)
		Process.register(pid,:server)
	end

	def echo do
		send :server,{self(),"hej"}
	end

	def stop do
		send :server, :stop
	end


	defp loop(db) do
		receive do
			{:write,key,data} ->
				loop(:db.write(key,data,db))
			{:delete,key}->
				loop(:db.delete(key,db))
			{:read,key,from}->
				#message result
				{stat,data}=:db.read(key,db)
				send from,data
			{:keys} -> 


			{from,msg} ->
				echo(["simon","says:",msg])
				loop(db)
			:stop -> 
				echo(["stop","stopping"])
			_ ->
				echo("_ error")
		end
	end


end