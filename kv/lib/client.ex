defmodule KV.Client do
	use GenServer
	


	#starts a db server and creates a new db 
	def start_link(server) do
	    GenServer.start_link(__MODULE__,:ok,name: server)
	end

#	def start_link(name) do
#	    {:ok, pid}=Task.start_link(fn -> loop(:db.new) end)
#		Process.register(pid,:server)
#		:ok
#	end

	#stops the db server 
	#def stop do
	#	send :server, :stop
	#	:ok
	#end

	#writes data to key, overwriting
	def write(server,key,data) do
		#send :server,{:write,key,data}
		#:ok
		GenServer.cast(server,{:write,key,data})

	end

	#delete key and data
	def delete(server,key) do
		#send :server,{:delete,key}
		#:ok
		GenServer.cast(server,{:delete,key})
	end

	#reads key and returns db result
	def read(server,key) do
	#	send :server,{:read,key,self}
	#	receive do
	#		res ->
	#			res
	#	end
		GenServer.call(server,{:read,key})
	end

	# returns all keys
	def keys(server) do
	#	send :server,{:keys,self}
	#	receive do
	#		res ->
	#			res
	#	end
		GenServer.call(server,{:keys})
	end

	#return keys contaning data
	def match(server,data) do
	#	send :server,{:match,data,self}
	#	receive do
	#		res -> 
	#			res
	#	end
		GenServer.call{server,{:match,data}}
	end


	## Server side

	def init(:ok) do
		{:ok,:db.new}
	end

	def handle_call({:read,key},_from,db) do
		{:reply,:db.read(key,db),db}
	end

	def handle_call({:keys},_from,db) do
		{:reply,:db.keys(db),db}
	end

	def handle_call({:match,data},_from,db) do
		{:reply,:db.match(data,db),db}
	end

	def handle_cast({:write,key,data},db) do
		{:noreply,:db.write(key,data,db)}
	end

	def handle_cast({:delete,key},db) do
		{:noreply,:db.delete(key,db)}
	end

	def handle_info(_msg, state) do
    	{:noreply, state}
	end

	# #db loop and server 
	# defp loop(db) do
	# 	receive do
	# 		{:write,key,data} ->
	# 			loop(:db.write(key,data,db))
	# 		{:delete,key}->
	# 			loop(:db.delete(key,db))
	# 		{:read,key,from}->
	# 			out=:db.read(key,db)
	# 			send from,out
	# 			loop(db)
	# 		{:keys,from} -> 
	# 			out = :db.keys(db)
	# 			send from,out
	# 			loop(db)
	# 		{:match,val,from} -> #? 
	# 			#{_,_,result} = :db.match(val,db)
	# 			result = :db.match(val,db)
	# 			send from,result
	# 			loop(db)

	# 		{from,msg} -> #used?
	# 			echo(["simon","says:",msg])
	# 			loop(db)
	# 		:stop -> # not calling loop and ending the server
	# 			#:db.destroy(db)
	# 			:ok
	# 		_ ->
	# 			echo("_ error")
	# 	end
	# end


end