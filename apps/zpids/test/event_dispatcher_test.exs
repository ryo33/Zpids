defmodule Zpids.EventDispatcherTest do
  use ExUnit.Case
  import Zpids.EventDispatcher, only: [dispatch: 1, listen: 1, listen_all: 0]

  defmodule Event1 do
    @behaviour Zpids.Event
    defstruct [:id]
    def to_selector(event), do: {__MODULE__, event.id}
  end
  defmodule Event2 do
    @behaviour Zpids.Event
    defstruct [:id]
    def to_selector(event), do: {__MODULE__, event.id}
  end

  test "listen nothing" do
    dispatch(%Event1{id: :a})
    dispatch(%Event2{id: :a})
    refute_receive %Event1{id: :a}
    refute_receive %Event2{id: :a}
  end

  test "listen and dispatch" do
    listen({Event1, :a})
    listen({Event2, :b})
    dispatch(%Event1{id: :a})
    dispatch(%Event2{id: :a})
    assert_receive %Event1{id: :a}
    refute_receive %Event2{id: :a}
  end

  test "dispatch from other process" do
    listen({Event1, :a})
    listen({Event2, :b})
    spawn fn -> dispatch(%Event1{id: :a}) end
    spawn fn -> dispatch(%Event2{id: :a}) end
    assert_receive %Event1{id: :a}
    refute_receive %Event2{id: :a}
  end

  test "listen_all" do
    listen_all()
    dispatch(%Event1{id: :a})
    dispatch(%Event2{id: :a})
    assert_receive %Event1{id: :a}
    assert_receive %Event2{id: :a}
  end
end
