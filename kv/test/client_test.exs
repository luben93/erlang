defmodule KV.ClientTest do
  use ExUnit.Case, async: true


  setup context do
    {:ok, client} = KV.Client.start_link#(context.test)
    {:ok, client: client}
  end

  test "spawns buckets",%{client: client} do
    #{:ok,_pid} = KV.Client.start_link
    assert KV.Client.read("shopping") == {:error,:instance}

  #  KV.Client.create(registry, "shopping")
   # assert {:ok, bucket} = KV.Client.lookup(registry, "shopping")

    KV.Client.write( "milk", 1)
    assert KV.Client.read( "milk") == {:ok,1}
    KV.Client.delete("milk")
    assert KV.Client.read( "milk") == {:error,:instance}
  end
end

