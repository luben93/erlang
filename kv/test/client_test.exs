defmodule KV.ClientTest do
  use ExUnit.Case, async: true


  setup context do
    {:ok, client} = KV.Client.start_link(:server)
    {:ok, client: client}
  end

  test "spawns buckets",%{client: client} do
    #{:ok,_pid} = KV.Client.start_link
    assert KV.Client.read(client,"shopping") == {:error,:instance}

  #  KV.Client.create(registry, "shopping")
   # assert {:ok, bucket} = KV.Client.lookup(registry, "shopping")

    KV.Client.write(client, "milk", 1)
    assert KV.Client.read(client, "milk") == {:ok,1}
    KV.Client.delete(client,"milk")
    assert KV.Client.read(client, "milk") == {:error,:instance}
  end
end

