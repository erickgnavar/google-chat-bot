defmodule Alfred.Commands.RunCommand do
  @moduledoc """
  Behaviour to define a command.
  """

  @doc """
  Define the function which will be called when the command is executed.
  """
  @callback run(map) :: {:ok, String.t()} | {:error, String.t()}

  @doc """
  Define the regex that will match the received command from chat event,
  the values extracted from this regex will be passed to command execution.
  """
  @callback regex :: Regex.t()

  @doc """
  A description about what the command does.
  """
  @callback help :: String.t()

  @doc """
  A sample command.
  """
  @callback sample :: String.t()
end
