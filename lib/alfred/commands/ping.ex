defmodule Alfred.Commands.Ping do
  @moduledoc """
  Sample command just to test everything is working properly.
  This wait 10 seconds to respond so we can check task status using a bot call.
  """
  @behaviour Alfred.Commands.RunCommand

  @impl true
  def run(%{"times" => times}) do
    times = String.to_integer(times)
    Process.sleep(times * 1_000)
    {:ok, "pong after #{times} secs"}
  end

  @impl true
  def regex, do: ~r/ping\ (?<times>\d+)/i

  @impl true
  def help, do: "Receive a number and wait until that time in seconds to respond."

  @impl true
  def sample, do: "ping 10"
end
