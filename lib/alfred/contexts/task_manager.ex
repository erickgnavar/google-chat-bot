defmodule Alfred.Contexts.TaskManager do
  @moduledoc """
  Handle persistence of task schema
  """
  import Ecto.Query

  alias Alfred.Repo
  alias Alfred.Contexts.Task

  @spec create_task(map) :: {:ok, Task.t()} | {:error, Ecto.Changeset.t()}
  def create_task(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Return a task for the given uid.
  """
  @spec get_task(Ecto.UUID.t()) :: Task.t() | nil
  def get_task(uid) do
    Task
    |> preload(:job)
    |> where(uid: ^uid)
    |> Repo.one()
  end

  @doc """
  For a given job_id return its related task.
  """
  @spec get_task_by_job_id(integer) :: Task.t() | nil
  def get_task_by_job_id(job_id) do
    Task
    |> where(job_id: ^job_id)
    |> Repo.one()
  end

  @doc """
  Given a job_id update the related task with the received result.
  """
  @spec update_result(integer, String.t()) :: any
  def update_result(job_id, result) do
    Task
    |> where(job_id: ^job_id)
    |> Repo.update_all(set: [result: result])
  end

  @doc """
  Update task fields using data from the given event
  This data is required to send a notification when the task is completed.
  """
  @spec update_task_from_chat_event(Ecto.UUID.t(), map) :: any
  def update_task_from_chat_event(uid, event) do
    text =
      event
      |> get_in(["message", "argumentText"])
      |> String.trim()

    attrs = [
      command: text,
      user_metadata: Map.get(event, "user"),
      chat_space: get_in(event, ["space", "name"]),
      # DM messages events don't have a threadKey value, in that case we just save nil
      chat_thread: Map.get(event, "threadKey")
    ]

    Task
    |> where(uid: ^uid)
    |> Repo.update_all(set: attrs)
  end
end
