defmodule SlackPresenceTest do
  use ExUnit.Case
  doctest SlackPresence

  test "greets the world" do
    assert SlackPresence.hello() == :world
  end
end
