defmodule RaggedData.Repo.Migrations.CreateAll do
  use Ecto.Migration

  def change do

    # News.Feed
    create table(:feeds) do
      add(:url,     :string)
      add(:name,    :string)
      add(:jfields, :map, default: "{}")
      timestamps()
    end

    # News.Post
    create table(:posts) do
      add(:feed_id, references(:feeds))
      add(:exid,    :string)
      add(:body,    :string)
      add(:jfields, :map, default: "{}")
      timestamps()
    end

    # Account.User
    create table(:users) do
      add(:name,         :string)
      add(:email,        :string)
      add(:uuid,         :string)
      add(:admin,        :boolean)
      add(:pwd_digest,   :string)
      add(:auth_token,   :string)
      add(:last_seen_at, :utc_datetime)
      add(:uistate,      :map, default: "{}")
      add(:jfields,      :map, default: "{}")
      timestamps()
    end

    # Account.Folder
    create table(:folders) do
      add(:user_id, references(:users))
      add(:name, :string)
      add(:jfields, :map, default: "{}")
      timestamps()
    end

    # Account.FeedLog
    create table(:feed_logs) do
      add(:folder_id,  references(:folders))
      add(:feed_id,    references(:feeds))
      add(:url,        :string)
      add(:name,       :string)
      add(:read_posts, :map, default: "[]")
      add(:jfields,    :map, default: "{}")
      timestamps()
    end

  end
end
