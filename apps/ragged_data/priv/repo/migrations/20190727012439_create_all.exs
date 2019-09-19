defmodule RaggedData.Repo.Migrations.CreateAll do
  use Ecto.Migration

  def change do

    # News.Feed
    create table(:feeds) do
      add(:url,        :string)
      add(:sync_count, :integer, default: 0)
      timestamps(type: :utc_datetime)
    end

    # News.Post
    create table(:posts) do
      add(:feed_id, references(:feeds, on_delete: :delete_all))
      add(:exid,    :string)
      add(:title,   :string)
      add(:body,    :text)
      add(:author,  :string)
      add(:link,    :string)
      timestamps(type: :utc_datetime)
    end
    create index(:posts, [:feed_id])
    create index(:posts, [:exid])
    create index(:posts, [:title])

    # Account.User
    create table(:users) do
      add(:name,         :string)
      add(:email,        :string)
      add(:admin,        :boolean)
      add(:pwd_hash,     :string)
      add(:auth_token,   :string)
      add(:last_seen_at, :utc_datetime)
      timestamps(type: :utc_datetime)
    end

    # Account.Folder
    create table(:folders) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:name, :string)
      timestamps(type: :utc_datetime)
    end
    create index(:folders, [:user_id])

    # Account.Register
    create table(:registers) do
      add(:folder_id, references(:folders, on_delete: :delete_all))
      add(:feed_id,   references(:feeds, on_delete: :delete_all))
      add(:name,       :string)
      timestamps(type: :utc_datetime)
    end
    create index(:registers, [:folder_id])
    create index(:registers, [:feed_id])

    # Account.ReadLogs
    create table(:read_logs) do
      add(:user_id,     references(:users, on_delete: :delete_all))
      add(:folder_id,   references(:folders, on_delete: :delete_all))
      add(:register_id, references(:registers, on_delete: :delete_all))
      add(:post_id,     references(:posts, on_delete: :delete_all))
    end
    create index(:read_logs, [:user_id])
    create index(:read_logs, [:folder_id])
    create index(:read_logs, [:register_id])
    create index(:read_logs, [:post_id])
    create unique_index(
      :read_logs, 
      [:user_id, :folder_id, :register_id, :post_id],
      name: :unique_read_log
    )
  end
end
