defmodule Alfred.Contexts.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]

  @fields [:result, :job_id]

  schema "tasks" do
    field(:uid, Ecto.UUID, autogenerate: true)
    field(:result, :string)
    belongs_to(:job, Oban.Job)

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
