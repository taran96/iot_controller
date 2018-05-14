defmodule IotControllerTest do
  use ExUnit.Case
  doctest IotController

  test "greets the world" do
    assert IotController.hello() == :world
  end
end
