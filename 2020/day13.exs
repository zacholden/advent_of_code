defmodule Day13 do
  @departure_time 1005162
  @buses "19,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,823,x,x,x,x,x,x,x,23,x,x,x,x,x,x,x,x,17,x,x,x,x,x,x,x,x,x,x,x,29,x,443,x,x,x,x,x,37,x,x,x,x,x,x,13" |> String.split(",")

  def part1 do
    @buses |> Enum.filter(&(&1 != "x")) |> Enum.map(&String.to_integer/1) |> find_earliest_bus_id
  end

  def find_earliest_bus_id(list) do
    bus_id = Enum.min_by(list, fn i -> i - rem(@departure_time, i) end)

    bus_id * (bus_id - rem(@departure_time, bus_id))
  end
end

Day13.part1 |> IO.puts
