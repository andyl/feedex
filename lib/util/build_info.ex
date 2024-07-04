defmodule Util.BuildInfo do

  @ data_file "priv/build_info.yml"

  def last_commit_time do
    {output, 0} = System.cmd("git", ["log", "-1", "--format=%ct"])
    timestamp = String.trim(output) |> String.to_integer()
    DateTime.from_unix!(timestamp) |> Calendar.strftime("%y-%m-%d_%H:%M PT")
  end

  def last_commit_hash do
    {output, 0} = System.cmd("git", ["log", "-1", "--format=%H"])
    String.trim(output)
    |> String.slice(-7, 7)
  end

  def current_branch do
    {output, 0} = System.cmd("git", ["rev-parse", "--abbrev-ref", "HEAD"])
    String.trim(output)
  end

  def current_time do
    DateTime.utc_now() |> Calendar.strftime("%y-%m-%d_%H:%M UTC")
  end

  def get_hostname do
    {:ok, hostname} = :inet.gethostname()
    List.to_string(hostname)
  end

  def map do
    %{
      compiled_at: current_time(),
      commit_time: last_commit_time(),
      commit_hash: last_commit_hash(),
      git_branch: current_branch(),
      build_host: get_hostname(),
    }
  end

  def json_map do
    map() |> Jason.encode!()
  end

  def yaml_map do
    map()
    |> Ymlr.document!()
  end

  def write do
    text = yaml_map()
    File.write!(@data_file, text)
  end

  def read do
    if File.exists?(@data_file) do
      YamlElixir.read_from_file(@data_file)
    else
      %{
        compiled_at: "NA",
        commit_time: "NA",
        commit_hash: "NA",
        git_branch:  "NA",
        build_host:  "NA"
      }
    end
  end

end
