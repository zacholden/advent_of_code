defmodule Day4 do
  @input File.read!("day4.txt") |> String.split("\n\n")
  @numbers hd(@input) |> String.split(",") |> Enum.map(&String.to_integer/1)
  @cards tl(@input)
         |> Enum.map(&String.trim/1)
         |> Enum.map(fn str ->
           String.split(str, "\n")
           |> Enum.map(fn row ->
             String.trim(row) |> String.split() |> Enum.map(&String.to_integer/1)
           end)
         end)

  def part1 do
    Enum.reduce_while(@numbers, MapSet.new(), fn number, acc ->
      called_numbers = MapSet.put(acc, number)

      case winning_card(called_numbers, @cards) do
        nil ->
          {:cont, called_numbers}

        card ->
          {:halt, score(card, number, called_numbers)}
      end
    end)
  end

  def part2 do
    find_last_card(@numbers, @cards, MapSet.new())
  end

  def find_last_card([number | tail], cards, called_numbers) do
    called_numbers = MapSet.put(called_numbers, number)

    case winning_card(called_numbers, cards) do
      nil ->
        find_last_card(tail, cards, called_numbers)

      card ->
        new_cards = Enum.reject(cards, fn c -> c == card end)

        if Enum.empty?(new_cards) do
          score(card, number, called_numbers)
        else
          find_last_card([number | tail], new_cards, called_numbers)
        end
    end
  end

  defp score(card, number, called_numbers) do
    List.flatten(card)
    |> Enum.reject(fn i -> MapSet.member?(called_numbers, i) end)
    |> Enum.sum()
    |> then(fn sum -> sum * number end)
  end

  defp winning_card(called_numbers, cards) do
    Enum.find(cards, fn card ->
      rows =
        Enum.any?(card, fn row ->
          Enum.all?(row, fn i -> MapSet.member?(called_numbers, i) end)
        end)

      columns =
        List.zip(card)
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.any?(fn column ->
          Enum.all?(column, fn i -> MapSet.member?(called_numbers, i) end)
        end)

      columns || rows
    end)
  end
end

Day4.part1() |> IO.inspect()
Day4.part2() |> IO.inspect()
