defmodule Day14 do
  @template "KHSNHFKVVSVPSCVHBHNP" |> String.codepoints()
  @rules File.read!("day14.txt")
         |> String.split("\n\n")
         |> List.last()
         |> String.split("\n", trim: true)
         |> Map.new(fn str -> String.split(str, " -> ") |> List.to_tuple() end)

  def part1 do
    Stream.iterate(@template, fn template -> insert(template) end)
    |> Stream.drop(10)
    |> Enum.take(1)
    |> hd
    |> Enum.frequencies()
    |> Enum.min_max_by(fn {_k, v} -> v end)
    |> then(fn {{_min_key, min}, {_max_key, max}} -> max - min end)
  end

  def part2 do
    pairs = Enum.chunk_every(@template, 2, 1, :discard) |> Map.new(fn [a, b] -> {a <> b, 1} end)
    letters = Enum.frequencies(@template)

    {_new_pairs, new_letters} =
      Stream.iterate({pairs, letters}, &insert_count(&1))
      |> Stream.drop(40)
      |> Enum.take(1)
      |> hd

    Enum.min_max_by(new_letters, fn {_k, v} -> v end)
    |> then(fn {{_min_key, min}, {_max_key, max}} -> max - min end)
  end

  def insert([e1, e2 | rest]) when is_map_key(@rules, e1 <> e2) do
    [e1, @rules[e1 <> e2] | insert([e2 | rest])]
  end

  def insert([e1, e2 | rest]) do
    [e1 | insert([e2 | rest])]
  end

  def insert(last), do: last

  def insert_count({pairs, letters}) do
    Enum.reduce(@rules, {pairs, letters}, fn {rule, result}, {pair_acc, letter_acc} ->
      [a, b] = String.codepoints(rule)

      count = Map.get(pairs, a <> b, 0)

      pairs =
        Map.update(pair_acc, a <> b, -count, fn val -> val - count end)
        |> Map.update(a <> result, count, fn val -> val + count end)
        |> Map.update(result <> b, count, fn val -> val + count end)

      letters = Map.update(letter_acc, result, count, fn val -> val + count end)

      {pairs, letters}
    end)
  end

  def rules, do: @rules
end

Day14.part1() |> IO.inspect()
Day14.part2() |> IO.inspect()
