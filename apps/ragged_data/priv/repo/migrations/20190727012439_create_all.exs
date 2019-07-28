defmodule RaggedData.Repo.Migrations.CreateAll do
  use Ecto.Migration

  def change do

    create table(:users) do
      add :email, :string
      add :enc_pwd, :string
    end

    create table(:folders) do
      add :name, :string
    end

    create table(:feeds) do
      add :user_id, references(:users)
      add :folder_id, references(:folders)
      add :name, :string
      add :url_input, :string
      add :url_active, :string
    end

    create table(:posts) do
      add :feed_id, references(:feeds)
      add :body, :string
      add :was_read, :boolean, default: false
    end

  end
end
