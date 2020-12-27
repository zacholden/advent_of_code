defmodule Day16 do
  # 1164645205103 too high
  @input File.read!('day16.txt') |> String.split("\n\n")
  @rules @input
         |> List.first()
         |> String.replace(" or ", ", ")
         |> String.replace("-", "..")
         |> String.replace(":", ",")
         |> String.split("\n")
         |> Enum.map(&String.split(&1, ", "))
         |> Enum.map(fn list -> list |> Enum.map(fn str -> String.replace(str, " ", "_") end) end)

  @rules
  |> Enum.each(fn [rule | ranges] ->
    def unquote(:"#{rule}")() do
      unquote(ranges) |> Enum.map(fn range -> Code.eval_string(range) |> elem(0) end)
    end
  end)

  @rule_pipeline @rules |> Enum.map(&List.first/1) |> Enum.map(&String.to_atom/1)
  @nearby_tickets @input
                  |> List.last()
                  |> String.split("\n")
                  |> tl
                  |> Enum.map(&String.split(&1, ","))
                  |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)

  @my_ticket @input |> Enum.at(1) |> String.replace("your ticket:", "") |> String.replace("\n", "") |> String.split(",") |> Enum.map(&String.to_integer/1)

  def part1 do
    invalid_ticket_rate(@nearby_tickets)
  end

  def part2 do
    discard_invalid_tickets(@nearby_tickets)
    |> lists_by_index
    |> find_rule
    |> Enum.filter(fn {rule, _index} ->  String.contains?(rule, "departure") end)
    |> Enum.map(fn {_rule, index} ->
      Enum.at(@my_ticket, index)
    end)
    |> Enum.reduce(1, fn int, acc -> int * acc end)
  end

  def find_rule(list) do
    find_rule(list, @rule_pipeline, [], Enum.with_index(list))
  end

  def find_rule(_columns, [], order, _original_columns) do
    Enum.sort_by(order, fn {_rule, index} -> index end)
    |> Enum.map(fn {rule, index} -> { Atom.to_string(rule), index} end)
  end

  def find_rule(columns, rules, order, original_columns) do
    { rule, column } = Enum.reduce_while(rules, 0, fn rule, acc ->
      hits = Enum.filter(columns, fn column ->
        Enum.all?(column, fn int ->
          Enum.any?(Kernel.apply(__MODULE__, rule, []), fn range ->
            Enum.member?(range, int)
          end)
        end)
      end)

      if Enum.count(hits) == 1 do
        { :halt, { rule, hd(hits) } }
      else
        { :cont, acc + 1 }
      end
    end)

    {_c, fixed_index } = Enum.find(original_columns, fn {oc, _id} -> oc == column end)

    IO.inspect({rule, fixed_index})

    find_rule(columns -- [column], rules -- [rule], order ++ [{rule, fixed_index}], original_columns)
  end

  def lists_by_index(list) do
    length = list |> hd |> Enum.count()

    0..(length - 1)
    |> Enum.map(fn int ->
      Enum.map(list, fn ticket -> Enum.at(ticket, int) end)
    end)
  end

  def discard_invalid_tickets(list) do
    Enum.filter(list, fn ticket -> valid_ticket?(ticket) end)
  end

  def valid_ticket?(ticket) do
    !Enum.any?(ticket, fn int -> 
      Enum.all?(@rule_pipeline, fn rule ->
        !Enum.any?(Kernel.apply(__MODULE__, rule, []), fn range ->
          Enum.member?(range, int)
        end)
      end)
    end)
  end

  def rule_applies?(rule, int) do
    Enum.any?(Kernel.apply(__MODULE__, rule, []), &Enum.member?(&1, int))
  end

  def invalid_ticket_rate(list) do
    List.flatten(list)
    |> Enum.filter(fn int ->
      Enum.all?(@rule_pipeline, fn str_rule ->
        !Enum.any?(Kernel.apply(__MODULE__, str_rule, []), fn range ->
          Enum.member?(range, int)
        end)
      end)
    end)
    |> Enum.sum()
  end

  def pipeline do
    @rule_pipeline
  end
end

Day16.part1() |> IO.inspect()
Day16.part2() |> IO.inspect()
