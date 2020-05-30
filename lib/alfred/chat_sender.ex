defmodule Alfred.ChatSender do
  @moduledoc """
  Handle notifications to chat from task results.
  """
  use GenServer
  alias Alfred.GoogleChatApi
  alias Alfred.Contexts.TaskManager
  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args), do: {:ok, %{}}

  def notify_task_result(job_id) do
    GenServer.cast(__MODULE__, {:notify_result, job_id})
  end

  def handle_cast({:notify_result, job_id}, state) do
    task = TaskManager.get_task_by_job_id(job_id)
    user = task.user_metadata["name"]
    # TODO: add a better presentation for task result
    text = "Hey <#{user}>, here is your result: #{task.result}"

    Logger.info("Notifying result of task:#{task.uid}")
    GoogleChatApi.send_message(task.chat_space, text, task.chat_thread)

    {:noreply, state}
  end
end
