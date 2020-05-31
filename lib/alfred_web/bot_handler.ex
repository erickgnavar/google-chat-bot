defmodule AlfredWeb.BotHandler do
  @moduledoc """
  Handle messages from chat webhook.
  """
  require Logger

  alias Alfred.Contexts.TaskManager
  alias Alfred.Dispatcher

  # when a new chat is implemented it should be added here
  @modules [
    Alfred.Commands.Ping
  ]

  @doc """
  Parses a google chat event and execute an action after it evaluate the content of the message.
  """
  @spec parse_event(map) :: map
  def parse_event(%{"type" => "ADDED_TO_SPACE", "user" => %{"name" => name}}) do
    # TODO: return a list of the available actions
    %{"text" => "Thanks  <#{name}> for adding me :)"}
  end

  def parse_event(%{"type" => "REMOVED_FROM_SPACE"}) do
    Logger.info("Bot was removed!")
    %{"text" => "bye"}
  end

  def parse_event(event) do
    event
    |> get_in(["message", "argumentText"])
    |> String.trim()
    |> parse_command(event)
  end

  @spec parse_command(String.t(), map) :: map
  defp parse_command("help", _) do
    help_text =
      @modules
      |> Enum.map(&("- " <> &1.help() <> " `#{&1.sample()}`"))
      |> Enum.join("\n")

    %{"text" => "Here are the available commands:\n#{help_text}"}
  end

  defp parse_command("check " <> uid, _) do
    uid
    |> TaskManager.get_task()
    |> task_card()
  end

  # TODO: add a way to define sync and async commands, only async commands should create a task
  # for now all sync commands should be defined before the below function

  defp parse_command(text, event) do
    # this will match all the defined commands in @modules and take the first match
    @modules
    |> Enum.map(&{Regex.named_captures(&1.regex(), text), &1})
    |> Enum.reject(fn {data, _module} -> is_nil(data) end)
    |> case do
      [] ->
        %{"text" => "Command not found"}

      [{args, module}] ->
        {:ok, task} =
          module
          |> module_name()
          |> Dispatcher.dispatch(Map.put(args, "event_metadata", event))

        TaskManager.update_task_from_chat_event(task.uid, event)

        %{
          "text" => "Task is being processed, you can ask for status with `check #{task.uid}`"
        }
    end
  end

  @spec module_name(atom) :: String.t()
  defp module_name(module) do
    module
    |> to_string()
    |> String.split(".")
    |> List.last()
  end

  # TODO: separate chat ui in a separate module
  defp task_card(nil), do: %{"text" => "Task not found"}

  defp task_card(task) do
    %{"text" => "#{task.job.state} -> result: #{task.result}"}
  end
end
