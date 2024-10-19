defmodule Feedex.Backup do
  def backup_dir do
    # path = Application.fetch_env!(:feedex, :data_dir) || ""
    # path = Application.fetch_env!(:feedex, :data_dir) || ""
    path = File.cwd!() <> "/data"
    IO.puts("-----------------------------------")
    IO.puts("PATH IS #{path}")
    IO.puts("-----------------------------------")
    unless File.exists?(path), do: File.mkdir!(path)
    unless File.dir?(path), do: raise("Dir does not exist (#{path})")
    path
  end

  def backup_path do
    backup_dir() <> "/backup.json"
  end
end
