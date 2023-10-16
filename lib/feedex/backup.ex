defmodule Feedex.Backup do

  def backup_dir do
    path = Application.fetch_env!(:feedex, :data_dir) || ""
    unless File.exists?(path), do: File.mkdir!(path)
    unless File.dir?(path), do: raise "Dir does not exist (#{path})"
    path
  end

  def backup_path do
    backup_dir() <> "/backup.json"
  end

  # def export do
  #   IO.puts("EXPORTING")
  # end

  # def import do
  #   File.read(backup_path())
  # end

end
