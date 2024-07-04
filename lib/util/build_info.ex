defmodule Util.BuildInfo do
  @data_file "priv/.build_info.yml"

  def in_git_repo? do
    current_dir = File.cwd!()
    git_dir = Path.join(current_dir, ".git")

    File.dir?(git_dir)
  end

  def last_commit_time do
    if in_git_repo?() do
      {output, 0} = System.cmd("git", ["log", "-1", "--format=%ct"])
      timestamp = String.trim(output) |> String.to_integer()
      DateTime.from_unix!(timestamp) |> Calendar.strftime("%y-%m-%d_%H:%M UTC")
    else
      "NG"
    end
  end

  def last_commit_hash do
    if in_git_repo?() do
      {output, 0} = System.cmd("git", ["log", "-1", "--format=%H"])

      String.trim(output)
      |> String.slice(0, 8)
    else
      "NG"
    end
  end

  def current_branch do
    if in_git_repo?() do
      {output, 0} = System.cmd("git", ["rev-parse", "--abbrev-ref", "HEAD"])
      String.trim(output)
    else
      "NG"
    end
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
      git_branch:  current_branch(),
      build_host:  get_hostname()
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
      case YamlElixir.read_from_file(@data_file) do
        {:ok, value} -> value
        value -> IO.inspect(value, label: "PLAIN_MATCH")
      end
    else
      %{
        "compiled_at" => "NA",
        "commit_time" => "NA",
        "commit_hash" => "NA",
        "git_branch"  => "NA",
        "build_host"  => "NA"
      }
    end
  end
end
