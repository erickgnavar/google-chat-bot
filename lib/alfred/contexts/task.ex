defmodule Alfred.Contexts.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]

  @fields [:result, :job_id, :user_metadata, :command, :chat_space, :chat_thread]
  @required_fields [:result, :job_id]

  schema "tasks" do
    field(:uid, Ecto.UUID, autogenerate: true)
    field(:result, :string)
    # TODO: replace this field when a users table is created
    field(:user_metadata, :map)
    field(:command, :string)
    field(:chat_space, :string)
    field(:chat_thread, :string)
    belongs_to(:job, Oban.Job)

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
