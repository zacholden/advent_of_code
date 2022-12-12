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
    run(@input)
    |> Enum.map(fn {cycle, score, _} -> {cycle, score} end)
    |> tl
    |> Enum.chunk_every(chunks)
    |> Enum.reduce("", fn list, acc ->
      line = Enum.map_join(list, fn {cycle, score} ->
        if score in [rem(cycle, 40) - 2, rem(cycle, 40) - 1, rem(cycle, 40)] do
          "#"
        else
          "."
        end
      end)

      acc <> line <> "\n"
    end)
    |> IO.puts
  end

  def run(input) do
      Enum.reduce(@input, [{0, 1, 0}], fn {command, incoming_add},
                                          acc = [{cycle, score, previous_add} | _tail] ->
        new_score = score + previous_add

        new_cycles =
          case command do
            "addx" ->
              [{cycle + 1, new_score, 0}, {cycle + 2, new_score, incoming_add}]

            "noop" ->
              [{cycle + 1, new_score, 0}]
          end

        Enum.reduce(new_cycles, acc, fn i, inner_acc -> [i | inner_acc] end)
      end)
      |> Enum.reverse()
  end
end

Day10.part1() |> IO.inspect()
Day10.part2() |> IO.inspect()
