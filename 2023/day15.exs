defmodule Day15 do
  def part1 do
    input()
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  def part2 do
    map = Map.new(0..255, fn i -> {i, []} end)

    input()
    |> Enum.map(fn str ->
      if String.contains?(str, "=") do
        String.split(str, "=") |> then(fn [str, num] -> {str, String.to_integer(num)} end)
      else
        String.split(str, "-") |> hd
      end
    end)
    |> Enum.reduce(map, fn
      {str, num}, acc ->
        box = hash(str)

        if List.keymember?(acc[box], str, 0) do
          Map.update!(acc, box, &List.keyreplace(&1, str, 0, {str, num}))
        else
          Map.update!(acc, box, &List.insert_at(&1, -1, {str, num}))
        end

      str, acc ->
        box = hash(str)

        Map.update!(acc, box, &List.keydelete(&1, str, 0))
    end)
    |> Enum.map(fn {k, list} ->
      Enum.with_index(list, 1)
      |> Enum.reduce(0, fn {{_lens, focal_length}, index}, acc ->
        (k + 1) * index * focal_length + acc
      end)
    end)
    |> Enum.sum()
  end

  def hash(str) when is_binary(str) do
    for <<char::8 <- str>>, reduce: 0 do
      acc -> acc |> Kernel.+(char) |> Kernel.*(17) |> rem(256)
    end
  end

  def hash(list) do
    Enum.reduce(list, 0, fn i, acc ->
      acc |> Kernel.+(i) |> Kernel.*(17) |> rem(256)
    end)
  end

  defp input do
    File.read!("day15.txt")
    |> String.trim()
    |> String.split(",")
  end
end

Day15.part1() |> IO.inspect()
Day15.part2() |> IO.inspect()
