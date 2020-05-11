defmodule RutTest do
  use ExUnit.Case
  doctest Rut

  test "greets the world" do
    assert Rut.hello() == :world
  end
end
