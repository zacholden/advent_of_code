defmodule Day7 do
  @cards ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
  @hands [[1, 1, 1, 1, 1], [2, 1, 1, 1], [2, 2, 1], [3, 1, 1], [3, 2], [4, 1], [5]]
         |> Enum.with_index()
         |> Map.new()
  @input File.read!("day7.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(&String.split/1)
         |> Enum.map(fn [cards, amount] ->
           {String.codepoints(cards), String.to_integer(amount)}
         end)

  def part1 do
    scores = @cards |> Enum.with_index() |> Map.new()

    Enum.sort(@input, fn {hand1, _}, {hand2, _} ->
      [score_a, score_b] = [hand_score(hand1), hand_score(hand2)]

      if score_a == score_b do
        compare_high_card(Enum.map(hand1, &scores[&1]), Enum.map(hand2, &scores[&1]))
      else
        score_a < score_b
      end
    end)
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, bid}, rank} -> bid * rank end)
    |> Enum.sum()
  end

  def part2 do
    scores = @cards |> Enum.with_index(1) |> Map.new() |> Map.put("J", 0)

    Enum.sort(@input, fn {hand1, _}, {hand2, _} ->
      [score_a, score_b] = [map_jokers(hand1) |> hand_score, map_jokers(hand2) |> hand_score]

      if score_a == score_b do
        compare_high_card(Enum.map(hand1, &scores[&1]), Enum.map(hand2, &scores[&1]))
      else
        score_a < score_b
      end
    end)
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, bid}, rank} -> bid * rank end)
    |> Enum.sum()
  end

  defp hand_score(cards) do
    @hands[Enum.frequencies(cards) |> Map.values() |> Enum.sort(:desc)]
  end

  defp map_jokers(cards) do
    pairs =
      Enum.frequencies(cards)
      |> Enum.sort_by(fn {_card, amount} -> amount end, :desc)
      |> Enum.reject(fn {card, _} -> card == "J" end)

    best_card = if pairs == [], do: "J", else: hd(pairs) |> elem(0)

    Enum.map(cards, fn c -> if c == "J", do: best_card, else: c end)
  end

  defp compare_high_card([a | resta], [b | restb]) when a == b,
    do: compare_high_card(resta, restb)

  defp compare_high_card([a | _], [b | _]), do: a < b
end

Day7.part1() |> IO.inspect()
Day7.part2() |> IO.inspect()
