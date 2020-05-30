defmodule Alfred.Repo.Migrations.AddTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add(:uid, :uuid, null: false)
      add(:result, :text, null: false)

      # job records eventually will be removed so we don't need to keep the relationship
      add(:job_id, references(:oban_jobs, on_delete: :nilify_all))

      timestamps(type: :utc_datetime_usec)
    end

    create(index(:tasks, [:job_id]))
  end
end
