defmodule Day11 do
  @input File.read!("day11.txt")
         |> String.replace(":", "")
         |> String.split("\n\n")
         |> Enum.map(fn str -> String.split(str, "\n", trim: true) |> Enum.map(&String.trim/1) end)
         |> Enum.map(fn [
                          "Monkey " <> monkey,
                          "Starting items " <> starting_items,
                          "Operation new = " <> operation,
                          "Test divisible by " <> divisor,
                          "If true throw to monkey " <> truthy_monkey,
                          "If false throw to monkey " <> falsy_monkey
                        ] ->
           [monkey, starting_items, operation, divisor, truthy_monkey, falsy_monkey]
         end)

  def part1 do
    monkeys =
      Map.new(@input, fn [monkey, starting_items, operation, divisor, truthy_monkey, falsy_monkey] ->
        {monkey,
         %{
           starting_items: String.split(starting_items, ", ") |> Enum.map(&String.to_integer/1),
           operation:
             case operation do
               "old * old" ->
                 fn x -> x * x end

               "old * " <> i ->
                 fn x -> x * String.to_integer(i) end

               "old + " <> i ->
                 fn x -> x + String.to_integer(i) end
             end,
           divisor: String.to_integer(divisor),
           truthy_monkey: truthy_monkey,
           falsy_monkey: falsy_monkey,
           inspections: 0
         }}
      end)

    keys = Map.keys(monkeys)

    Enum.reduce(1..20, monkeys, fn _i, monkeys ->
      Enum.reduce(keys, monkeys, fn key, monkeys ->
        monkey = monkeys[key]

        inspect_items(key, monkey, monkey.starting_items, monkeys)
      end)
    end)
    |> Enum.map(fn {_k, monkey} -> monkey.inspections end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  def inspect_items(_, _, [], monkeys), do: monkeys

  def inspect_items(key, monkey, [item | rest], monkeys) do
    updated_monkeys =
      update_in(monkeys, [key, :starting_items], &tl(&1))
      |> update_in([key, :inspections], &(&1 + 1))

    new_worry_level = monkey.operation.(item) |> div(3)

    updated_monkeys =
      if rem(new_worry_level, monkey.divisor) == 0 do
        update_in(
          updated_monkeys,
          [monkey.truthy_monkey, :starting_items],
          &(&1 ++ [new_worry_level])
        )
      else
        update_in(
          updated_monkeys,
          [monkey.falsy_monkey, :starting_items],
          &(&1 ++ [new_worry_level])
        )
      end

    inspect_items(key, monkey, rest, updated_monkeys)
  end
end

Day11.part1() |> IO.inspect()
# Day11.part2() |> IO.inspect()
