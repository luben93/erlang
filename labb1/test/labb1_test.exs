defmodule Labb1Test do
  use ExUnit.Case
  doctest Labb1

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "start and get info" do
  	{:ok,pid} = Labb1.start_link(5,2)
  	assert {:ok, [total: 5, taken: 2, free: 3]} == Labb1.get_info(pid)
  end

  test "taken and return " do 
  		{:ok,pid} = Labb1.start_link(5,2)
  		{:ok, [total: 5, taken: 2, free: 3]} = Labb1.get_info(pid)
  		:ok=Labb1.release_cycle(pid)
  		:ok=Labb1.release_cycle(pid)
  		:ok=Labb1.release_cycle(pid)
  		{:error,:empty}=Labb1.release_cycle(pid)
  		:ok=Labb1.secure_cycle(pid)
  		:ok=Labb1.secure_cycle(pid)
   		:ok=Labb1.secure_cycle(pid)
  		:ok=Labb1.secure_cycle(pid)
  		:ok=Labb1.secure_cycle(pid)
  		{:error,:full}=Labb1.secure_cycle(pid)
  		assert {:ok, [total: 5, taken: 0, free: 5]} == Labb1.get_info(pid)		

  end

  test "multiple clients" do 
  		{:ok,pid} = Labb1.start_link(5,2)
  		{:ok, [total: 5, taken: 2, free: 3]} = Labb1.get_info(pid)
  		:ok=Labb1.release_cycle(pid)
  		:ok=Labb1.release_cycle(pid)
  		:ok=Labb1.release_cycle(pid)
  		 {:error,:empty}=Labb1.release_cycle(pid)

  		{:ok,pid2} = Labb1.start_link(10,4)
  		{:ok, [total: 10, taken: 4, free: 6]} = Labb1.get_info(pid2)
  		:ok=Labb1.release_cycle(pid2)

   		 {:error,:empty}=Labb1.release_cycle(pid)

  end


end
