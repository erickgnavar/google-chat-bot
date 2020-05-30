defmodule Alfred.Commands.Ping do
  @moduledoc """
  Sample command just to test everything is working properly.
  This wait 10 seconds to respond so we can check task status using a bot call.
  """
  @behaviour Alfred.Commands.RunCommand

  @impl true
  def run(_) do
    Process.sleep(10_000)
    {:ok, "pong"}
  end
end
