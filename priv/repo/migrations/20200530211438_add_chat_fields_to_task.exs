defmodule Alfred.Repo.Migrations.AddChatFieldsToTask do
  use Ecto.Migration

  def up do
    alter table(:tasks) do
      add(:user_metadata, :map)
      add(:command, :string)
      add(:chat_space, :string)
      add(:chat_thread, :string)
    end
  end

  def down do
    alter table(:tasks) do
      remove(:user_metadata, :map)
      remove(:command, :string)
      remove(:chat_space, :string)
      remove(:chat_thread, :string)
    end
  end
end
