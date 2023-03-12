defmodule FeedexWeb.Cache.UiParams do

  @moduledoc """
  Tools to manipulate UI params.any()

  Used to support `push_state` and `handle_params`.

  UiState struct:

  modes: view, edit, add_feed, add_folder, edit_feed, edit_folder

  defstruct mode: "view",
            usr_id: nil,
            fld_id: nil,
            reg_id: nil,
            pst_id: nil,
            timestamp: DateTime.utc_now()
  """

  def clean(params) do
    params
    |> Map.delete(:usr_id)
    |> drop_nil_values()
    |> drop_view_mode()
  end

  def merge(old, params) do
    new = params |> sanitize_params()
    IO.inspect(params, label: "PARAMZZ")
    IO.inspect(old, label: "OLD")
    IO.inspect(new, label: "NEW")
    merge_params(old, new) |> IO.inspect(label: "MERGED")
  end

  def strip(params) do
    params
    |> Map.delete(:__struct__)
    |> Map.delete(:timestamp)
  end

  def to_params(params) do
    params
    |> Map.delete(:usr_id)
    |> drop_nil_values()
  end

  defp drop_nil_values(map) do
    Map.filter(map, fn({_, value}) -> value != nil end)
  end

  defp sanitize_params(params) do
    num =
      params
      |> Map.delete("mode")
      |> Enum.count()

    case num do
      0 -> %{}
      1 -> params |> atomify_keys() |> numify_vals()
      # _ -> params |> atomify_keys() |> numify_vals()
      _ -> %{mode: "view"}
    end
  end

  def merge_params(old, params) do
    new = params |> sanitize_params()
    Map.merge(base(old), new)
  end

  defp base(state) do
    state
  end

  defp drop_view_mode(map) do
    Map.filter(map, fn({_, value}) -> value != "view" end)
    # map
  end

  defp numify_vals(map) do
    newmap = %{
      fld_id: map[:fld_id] |> numify(),
      reg_id: map[:reg_id] |> numify(),
      pst_id: map[:pst_id] |> numify(),
    }
    Map.merge(map, newmap)
  end

  defp numify(string) do
    case string do
      nil -> nil
      "" -> nil
      val -> Integer.parse(val) |> elem(0)
    end
  end

  def atomify_keys(map) do
    map
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
  end

end
