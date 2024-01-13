defmodule Day10 do
  @input File.stream!("day10.txt")
         |> Enum.map(&String.trim/1)
         |> Enum.map(fn
           "addx " <> int -> {"addx", String.to_integer(int)}
           "noop" -> {"noop", 0}
         end)

  def part1 do
    output = run(@input)

    indexes = [20, 60, 100, 140, 180, 220]

    Enum.map(indexes, fn index -> Enum.at(output, index) end)
    |> Enum.map(fn {cycle, score, _} -> cycle * score end)
    |> Enum.sum()
  end

  def part2 do
    chunks = 40

    run(@input)
    |> tl
    |> Enum.map(fn {cycle, score, _} -> {cycle, score} end)
    |> Enum.chunk_every(chunks)
    |> Enum.map_join("\n", fn list ->
      Enum.map_join(list, fn {cycle, score} ->
        position = cycle - 1
        middle = rem(position, chunks)

        if score in (middle - 1)..(middle + 1) do
          "#"
        else
          "."
        end
      end)
    end)
  end

  def run(input) do
    Enum.reduce(input, [{0, 1, 0}], fn {command, incoming_add},
                                       acc = [{cycle, score, previous_add} | _tail] ->
      new_score = score + previous_add

      case command do
        "addx" ->
          [{cycle + 2, new_score, incoming_add}, {cycle + 1, new_score, incoming_add} | acc]

        "noop" ->
          [{cycle + 1, new_score, incoming_add} | acc]
      end
    end)
    |> Enum.reverse()
  end
end

Day10.part1() |> IO.inspect()
Day10.part2() |> IO.puts()
