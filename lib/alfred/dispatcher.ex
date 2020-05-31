defmodule Alfred.Dispatcher do
  @moduledoc """
  Dispatch tasks
  """

  alias Alfred.Contexts.TaskManager

  @doc """
  Dispatch a new task for the given module name, the task will run with the given args.

  For example if web have `Alfred.Dispatcher.dispatch("demo", args)` thiw will call the function `Alfred.Commands.Foo.run/1`
  passing it `args` as a single argument.
  """
  @spec dispatch(String.t(), [any]) :: {:ok, struct}
  def dispatch(module_name, args) do
    # TODO: replace module_name with the module itself
    {:ok, job} =
      %{
        "module_name" => module_name,
        "args" => args
      }
      |> Alfred.Worker.new()
      |> Oban.insert()

    TaskManager.create_task(%{job_id: job.id, result: "not yet"})
  end
end
