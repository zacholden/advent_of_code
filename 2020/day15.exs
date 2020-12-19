defmodule Day15 do
  @input [2, 0, 6, 12, 1, 3]
  # part 1
  @goal 2020
  # part 2
  @goal 30_000_000

  def part1 do
    memory_game(@input, %{}, nil, 1)
  end

  def memory_game([head | tail], game_state, _last_number, turn) do
    new_game_state = Map.put(game_state, head, {turn, nil})

    memory_game(tail, new_game_state, head, turn + 1)
  end

  def memory_game([], game_state, last_number, @goal) do
    {a, b} = Map.get(game_state, last_number)

    a - b
  end

  def memory_game([], game_state, last_number, turn) do
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
end

Day15.part1() |> IO.puts()
