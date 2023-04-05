defmodule NewsForum.Utils do
  def display_datetime(dt) do
    {:ok, dt_new} = DateTime.from_naive(dt, "Etc/UTC")
    DateTime.to_date(dt_new)
    |> Date.to_string()
  end
end