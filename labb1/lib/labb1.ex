defmodule Labb1 do
	use GenServer

	#client

	@doc"""
	starts station
	`ref` = unique id for station
	"""
	def start_link(total,taken) do
		#something return {:ok,ref}
	end

	def release_cycle(ref) do
		#something return :ok | {:error,:empty}
	end

	def secure_cycle(ref) do
		#something return :ok | {:error,:full}
	end

	def get_info(ref) do
		#{:ok,[{:total,total},{:taken,taken},{:free,free}]}
	end

	def init(:ok) do
		#state
	end

	def handle_call({:call,var},_from,state) do
		:ok
	end

	def handle_cast({:cast,var},state) do
		#no return
	end

end
