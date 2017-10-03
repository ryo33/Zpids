defmodule Zpids.GameTest do
  use ExUnit.Case
  doctest Zpids.Game

  test "greets the world" do
    assert Zpids.Game.hello() == :world
  end
end
