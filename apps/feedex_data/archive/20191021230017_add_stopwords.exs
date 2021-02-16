defmodule FeedexData.Repo.Migrations.AddStopwords do
  use Ecto.Migration

  def change do

    alter table(:folders) do
      add(:stopwords, :string)
    end

  end
end
