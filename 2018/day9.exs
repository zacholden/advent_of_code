defmodule Day9 do
  def part1 do
    {players, final_score} = input()
    scores = Map.new(1..players, fn i -> {i, 0} end)

    game_state = {[0], 0, 1, scores, 1}

    Stream.cycle(1..players)
    |> Enum.reduce_while(game_state, fn player, {marbles, current, next, scores, length} ->
      new_state = if rem(next, 23) == 0 do
        idx = current - 7
        new_index = if idx < 0, do: length + idx, else: idx
        {value, marbles} = List.pop_at(marbles, new_index)
        {marbles, new_index, next + 1, Map.update!(scores, player, & &1 + next + value), length - 1}
      else
        idx = current + 2
        new_index = if idx >= length, do: rem(idx, length), else: idx
        {List.insert_at(marbles, new_index, next), new_index, next + 1, scores, length + 1}
      end
      if next == final_score, do: {:halt, scores}, else: {:cont, new_state}
    end)
    |> Map.values
    |> Enum.max
  end

  def input do
    File.read!("day9.txt")
    |> String.trim
    |> String.split
    |> Enum.map(&Integer.parse/1)
    |> Enum.filter(& is_tuple(&1))
    |> Enum.map(fn {a, ""} -> a end)
    |> List.to_tuple
  end
end

Day9.part1 |> IO.puts
