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
  Given a job_id update the related task with the received result.
  """
  @spec update_result(integer, String.t()) :: any
  def update_result(job_id, result) do
    Task
    |> where(job_id: ^job_id)
    |> Repo.update_all(set: [result: result])
  end
end
