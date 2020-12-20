defmodule Day15 do
  @input [2, 0, 6, 12, 1, 3]
  @goal_part_1 2020
  # part 2
  @goal_part_2 30_000_000
  # Switching part 2 from using a map to using ets brought the runtime down from 30 seconds to 6

  def part1 do
    memory_game(@input, %{}, nil, 1)
  end

  def part2 do
    memory_game_ets(@input, :ets.new(:game_state, [:set, :protected]), nil, 1)
  end

  defp memory_game([head | tail], game_state, _last_number, turn) do
    new_game_state = Map.put(game_state, head, {turn, nil})

    memory_game(tail, new_game_state, head, turn + 1)
  end

  defp memory_game([], game_state, last_number, @goal_part_1) do
    {a, b} = Map.get(game_state, last_number)

    a - b
  end

  defp memory_game([], game_state, last_number, turn) do
    {recent, previous} = Map.get(game_state, last_number)

    number =
      if previous do
        recent - previous
      else
        0
      end

    new_game_state = Map.update(game_state, number, {turn, nil}, fn {a, _b} -> {turn, a} end)

    memory_game([], new_game_state, number, turn + 1)
  end

  defp memory_game_ets([head | tail], game_state, _last_number, turn) do
    :ets.insert(game_state, {head, {turn, nil}})

    memory_game_ets(tail, game_state, head, turn + 1)
  end

  defp memory_game_ets([], game_state, last_number, @goal_part_2) do
    [{_key, { a, b} }] = :ets.lookup(game_state, last_number)

    a - b
  end

  defp memory_game_ets([], game_state, last_number, turn) do
    [{_key, {recent, previous}}] = :ets.lookup(game_state, last_number)

    number =
      if previous do
        recent - previous
      else
        0
      end

    :ets.insert(game_state, {number, {turn, recent}})

    memory_game_ets([], game_state, number, turn + 1)
  end
end

Day15.part1() |> IO.puts()
Day15.part2() |> IO.puts()
