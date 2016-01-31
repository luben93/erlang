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

	def write(key,data) do
		send :server,{:write,key,data}
	end

	def delete(key) do
		send :server,{:delete,key}
	end

	def read(key) do
		send :server,{:read,key,self}
		receive do
			res ->
				res
		end
	end

	def keys do
		send :server,{:keys,self}
		receive do
			res ->
				res
		end
	end

	def match(val) do
		send :server,{:match,val,self}
		receive do
			res -> 
				res
		end
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
				loop(db)
			{:keys,from} -> 
				{db, result} = :db.keys(db)
				send from,result
				loop(db)
			{:match,val,from} -> #test this
				{_,_,result} = :db.match(val,db)
				send from,result
				loop(db)

			{from,msg} ->
				echo(["simon","says:",msg])
				loop(db)
			:stop -> 
				:db.destroy(db)
				echo(["stop","stopping"])
			_ ->
				echo("_ error")
		end
	end


end