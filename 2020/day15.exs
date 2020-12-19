defmodule Day15 do
  @input [2, 0, 6, 12, 1, 3]
  # part 1
  @goal 2020
  # part 2
  @goal 30_000_000
  # part 2 is very slow it might be faster if tuples were used instead of a list
  # to store the turn the number occured at

  def part1 do
    memory_game(@input, %{}, nil, 1)
  end

  def memory_game([head | tail], game_state, _last_number, turn) do
    new_game_state =
      Map.update(game_state, head, [turn], fn list -> [turn | list] |> Enum.take(2) end)

    memory_game(tail, new_game_state, head, turn + 1)
  end

  def memory_game([], game_state, last_number, @goal) do
    [head | tail] = Map.get(game_state, last_number)

    if tail == [] do
      0
    else
      head - hd(tail)
    end
  end

  def memory_game([], game_state, last_number, turn) do
    [head | tail] = Map.get(game_state, last_number)

    number =
      if tail == [] do
        0
      else
        head - hd(tail)
      end

    new_game_state =
      Map.update(game_state, number, [turn], fn list -> [turn | list] |> Enum.take(2) end)

    memory_game([], new_game_state, number, turn + 1)
  end
end

Day15.part1() |> IO.puts()
