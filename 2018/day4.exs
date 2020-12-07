defmodule Day4 do
  def part1 do
    File.read!('day4.txt')
    |> String.split("\n", trim: true)
    |> Enum.map(&String.replace(&1, "[", ""))
    |> Enum.map(&String.replace(&1, "]", ":00"))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&parse_time/1)
    |> Enum.sort_by(fn dt -> {hd(dt).year, hd(dt).month, hd(dt).day, hd(dt).hour, hd(dt).minute, hd(dt).second } end)
    |> Enum.map(&parse_data/1)
    |> record_minutes(Map.new)
    |> find_laziest_guard
  end

  def part2 do
    File.read!('day4.txt')
    |> String.split("\n", trim: true)
    |> Enum.map(&String.replace(&1, "[", ""))
    |> Enum.map(&String.replace(&1, "]", ":00"))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&parse_time/1)
    |> Enum.sort_by(fn dt -> {hd(dt).year, hd(dt).month, hd(dt).day, hd(dt).hour, hd(dt).minute, hd(dt).second } end)
    |> Enum.map(&parse_data/1)
    |> record_minutes(Map.new)
    |> find_laziest_guards
    # the answer is minute 24
  end


  def find_laziest_guard(map) do
    { guard, minutes } = Enum.sort_by(map, fn { _k, v } -> Enum.count(v) end)
    |> Enum.reverse
    |> List.first

    { minute, _sleeping_time } = minutes
             |> Enum.reduce(%{}, fn i, acc -> Map.update(acc, i, 1, &(&1 + 1)) end)
             |> Enum.sort_by(fn { _k, v } -> v end)
             |> Enum.reverse
             |> List.first
             
    String.to_integer(guard) * minute
  end

  def find_laziest_guards(map) do
    remap_keys(Map.keys(map), map)
    |> Enum.map(fn {k, v} -> %{ k => List.first(v) } end)
  end

  def remap_keys([head | tail], map) do
    new_val = Map.get(map, head)
    |> Enum.reduce(%{}, fn i, acc -> Map.update(acc, i, 1, &(&1 + 1)) end)
    |> Enum.sort_by(fn { _k, v } -> v end)
    |> Enum.reverse

    new_map = Map.put(map, head, new_val)
    remap_keys(tail, new_map)
  end

  def remap_keys([], map), do: map

  def record_minutes([head | tail], map) do
    updated_map = record_entry(head, map)
    record_minutes(tail, updated_map)
  end

  def record_minutes([], map) do
    map
    |> Map.delete(:current_guard)
    |> Map.delete(:from)
    |> Map.delete(:sleeping)
  end

  def record_entry([head | tail], map) do
    case hd(tail) do
      "falls" ->
        Map.put(map, :from, head.minute)
      "wakes" ->
        minutes = ((Map.get(map, :from))..head.minute - 1) |> Enum.to_list
        guard = Map.get(map, :current_guard)
        old_minutes = Map.get(map, guard, [])
        new_minutes = (old_minutes ++ minutes)

        Map.put(map, guard, new_minutes) |> Map.put(:sleeping, false)
      _ ->
        Map.put(map, :current_guard, hd(tail)) |> Map.put(:sleeping, false)
    end
  end

  def parse_data([head | tail]) do
    new_tail = tail
    |> Enum.join("")
    |> String.replace("beginsshift", "")
    |> String.replace("Guard#", "")
    |> String.replace("asleep", "")
    |> String.replace("up", "")

    [ head, new_tail ]
  end
  

  def parse_time(list) do
    [date | [time | tail] ] = list
    [ NaiveDateTime.from_iso8601!(date <> " " <> time) | tail ]
  end
end

#Day4.part1() |> IO.puts()
#Day4.part2() |> IO.puts()
