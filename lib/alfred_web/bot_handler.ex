defmodule AlfredWeb.BotHandler do
  @moduledoc """
  Handle messages from chat webhook.
  """
  require Logger

  alias Alfred.Contexts.TaskManager
  alias Alfred.Dispatcher

  def parse_event(%{"type" => "ADDED_TO_SPACE", "user" => %{"name" => name}}) do
    %{"text" => "Thanks  <#{name}> for adding me :)"}
  end

  def parse_event(%{"type" => "REMOVED_FROM_SPACE"}) do
    Logger.info("Bot was removed!")
    %{"text" => "bye"}
  end

  def parse_event(%{
        "message" => %{"argumentText" => text}
      }) do
    text
    |> String.trim()
    |> parse_command()
  end

  defp parse_command("ping") do
    {:ok, task} = Dispatcher.dispatch("ping", nil)

    %{
      "text" => "Task is being processed, you can ask for status with `check #{task.uid}`"
    }
  end

  defp parse_command("check " <> uid) do
    uid
    |> TaskManager.get_task()
    |> task_card()
  end

  defp parse_command(_) do
    %{"text" => "Command not found"}
  end

  # TODO: separate chat ui in a separate module
  defp task_card(nil), do: %{"text" => "Task not found"}

  defp task_card(task) do
    %{"text" => "#{task.job.state} -> result: #{task.result}"}
  end
end
