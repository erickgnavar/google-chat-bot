defmodule AlfredTest do
  use ExUnit.Case
  doctest Alfred

  test "greets the world" do
    assert Alfred.hello() == :world
  end
end
