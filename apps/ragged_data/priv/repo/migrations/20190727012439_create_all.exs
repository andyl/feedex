defmodule RaggedData.Repo.Migrations.CreateAll do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:name,         :string)
      add(:email,        :string)
      add(:uuid,         :string)
      add(:admin,        :boolean)
      add(:pwd_digest,   :string)
      add(:auth_token,   :string)
      add(:last_seen_at, :utc_datetime)
      add(:jfields,      :map, default: "{}")
      timestamps()
    end

    create table(:folders) do
      add(:name, :string)
      timestamps()
    end

    create table(:feeds) do
      add(:user_id,    references(:users))
      add(:folder_id,  references(:folders))
      add(:name,       :string)
      add(:url_input,  :string)
      add(:url_active, :string)
      add(:jfields,    :map, default: "{}")
      timestamps()
    end

    create table(:posts) do
      add(:feed_id,  references(:feeds))
      add(:body,     :string)
      add(:was_read, :boolean, default: false)
      add(:jfields,  :map, default: "{}")
      timestamps()
    end
  end
end
