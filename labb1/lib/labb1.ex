defmodule Labb1 do
	use GenServer

	#client

	@doc"""
	starts station
    
	`ref` = unique id for station (pid)
	"""
	def start_link(total,taken) do
        if total > 0 do
            GenServer.start_link(__MODULE__,{total,taken},[])
	    else 
            {:error,"total must be greater than zero"}
        end
    end

	#quickstart for testing
	def st do 
		start_link(5,2)
	end

	def release_cycle(ref) do
		#something return :ok | {:error,:empty}
		GenServer.call(ref,{:take})
	end

	def secure_cycle(ref) do
		#something return :ok | {:error,:full}
		GenServer.call(ref,{:return})
	end

	def get_info(ref) do
		GenServer.call(ref,{:info})
	end

	#server{myInt, _} = :string.to_integer(to_char_list("23"))

	def init({total,taken}=state) do
		{:ok,state}
	end

	def handle_call({:take},_from,{total,taken}=state) do
		cond do
			total == taken -> 
				{:reply,{:error,:empty},state}
			true ->
				{:reply,:ok,{total,taken+1}}
		end
	end

	def handle_call({:return},_from,{total,taken}=state) do
		cond do 
			0 == taken ->
				{:reply,{:error,:full},state}
			true ->
				{:reply,:ok,{total,taken-1}}

		end
	end


	def handle_call({:info},_from,{total,taken}=state) do #? define ref in vars to match state?
		{:reply,{:ok,[{:total,total},{:taken,taken},{:occupied,total - taken}]},state}
	end

end
