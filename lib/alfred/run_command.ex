defmodule Alfred.Commands.RunCommand do
  @moduledoc """
  Behaviour to define a command.
  """

  @doc """
  Define the function which will be called when the command is executed.
  """
  @callback run([any]) :: {:ok, String.t()} | {:error, String.t()}
end
