defmodule Alfred.Worker do
  use Oban.Worker, queue: :default, max_attempts: 3
  alias Alfred.Contexts.TaskManager

  require Logger

  @impl true
  def perform(%{"module_name" => name, "args" => args}, job) do
    module_name = Macro.camelize(name)
    module = Module.safe_concat(Alfred.Commands, module_name)

    Logger.info("Executing #{module} with args #{inspect(args)} in job #{job.id}")

    case apply(module, :run, [args]) do
      {:ok, result} ->
        TaskManager.update_result(job.id, result)
        Alfred.ChatSender.notify_task_result(job.id)
        :ok

      {:error, reason} ->
        {:error, reason}
    end
  end
end
