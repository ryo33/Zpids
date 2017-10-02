defmodule Zpid.GameTest do
  use ExUnit.Case
  doctest Zpid.Game

  test "greets the world" do
    assert Zpid.Game.hello() == :world
  end
end
