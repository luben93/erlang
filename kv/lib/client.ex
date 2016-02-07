defmodule Client do
	#use GenServer
	


	#starts a db server and creates a new db 
	def start do
	    {:ok, pid}=Task.start_link(fn -> loop(:db.new) end)
		Process.register(pid,:server)
		:ok
	end

	#stops the db server 
	def stop do
		send :server, :stop
		:ok
	end

	#writes data to key, overwriting
	def write(key,data) do
		send :server,{:write,key,data}
		:ok
	end

	#delete key and data
	def delete(key) do
		send :server,{:delete,key}
		:ok
	end

	#reads key and returns db result
	def read(key) do
		send :server,{:read,key,self}
		receive do
			res ->
				res
		end
	end

	# returns all keys
	def keys do
		send :server,{:keys,self}
		receive do
			res ->
				res
		end
	end

	#return keys contaning data
	def match(data) do
		send :server,{:match,data,self}
		receive do
			res -> 
				res
		end
	end

	#db loop and server 
	defp loop(db) do
		receive do
			{:write,key,data} ->
				loop(:db.write(key,data,db))
			{:delete,key}->
				loop(:db.delete(key,db))
			{:read,key,from}->
				out=:db.read(key,db)
				send from,out
				loop(db)
			{:keys,from} -> 
				out = :db.keys(db)
				send from,out
				loop(db)
			{:match,val,from} -> #? 
				#{_,_,result} = :db.match(val,db)
				result = :db.match(val,db)
				send from,result
				loop(db)

			{from,msg} -> #used?
				echo(["simon","says:",msg])
				loop(db)
			:stop -> # not calling loop and ending the server
				#:db.destroy(db)
				:ok
			_ ->
				echo("_ error")
		end
	end


end