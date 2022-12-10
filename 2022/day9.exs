defmodule Day9 do
  @input File.stream!("day9.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(&String.split/1)
         |> Enum.map(fn [dir, amount] -> {dir, String.to_integer(amount)} end)

  def part1 do
    Enum.reduce(@input, [{{0, 0}, {0, 0}}], fn {dir, amount}, acc ->
      [{head, tail} | _rest] = acc

      moves = move(dir, amount, head, tail)

      Enum.reduce(moves, acc, fn move, inner_acc -> [move | inner_acc] end)
    end)
    |> Enum.map(fn {_head, tail} -> tail end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def move("U", amount, {hx, hy}, {tx, ty}) do
    Enum.reduce(1..amount, [{{hx, hy}, {tx, ty}}], fn _, acc ->
      [{{hx, hy}, {tx, ty}} | _tail] = acc

      new_hy = hy + 1

      new_tail =
        cond do
          new_hy - 2 == ty && hx == tx ->
            {tx, ty + 1}

          new_hy - 2 == ty && hx < tx ->
            {tx - 1, ty + 1}

          new_hy - 2 == ty && hx > tx ->
            {tx + 1, ty + 1}

          true ->
            {tx, ty}
        end

      [{{hx, new_hy}, new_tail} | acc]
    end)
    |> Enum.take(amount)
    |> Enum.reverse()
  end

  def move("R", amount, {hx, hy}, {tx, ty}) do
    Enum.reduce(1..amount, [{{hx, hy}, {tx, ty}}], fn _, acc ->
      [{{hx, hy}, {tx, ty}} | _tail] = acc
      new_hx = hx + 1

      new_tail =
        cond do
          new_hx - 2 == tx && hy == ty ->
            {tx + 1, ty}

          new_hx - 2 == tx && hy < ty ->
            {tx + 1, ty - 1}

          new_hx - 2 == tx && hy > ty ->
            {tx + 1, ty + 1}

          true ->
            {tx, ty}
        end

      [{{new_hx, hy}, new_tail} | acc]
    end)
    |> Enum.take(amount)
    |> Enum.reverse()
  end

  def move("L", amount, {hx, hy}, {tx, ty}) do
    Enum.reduce(1..amount, [{{hx, hy}, {tx, ty}}], fn _, acc ->
      [{{hx, hy}, {tx, ty}} | _tail] = acc
      new_hx = hx - 1

      new_tail =
        cond do
          new_hx + 2 == tx && hy == ty ->
            {tx - 1, ty}

          new_hx + 2 == tx && hy < ty ->
            {tx - 1, ty - 1}

          new_hx + 2 == tx && hy > ty ->
            {tx - 1, ty + 1}

          true ->
            {tx, ty}
        end

      [{{new_hx, hy}, new_tail} | acc]
    end)
    |> Enum.take(amount)
    |> Enum.reverse()
  end

  def move("D", amount, {hx, hy}, {tx, ty}) do
    Enum.reduce(1..amount, [{{hx, hy}, {tx, ty}}], fn _, acc ->
      [{{hx, hy}, {tx, ty}} | _tail] = acc
      new_hy = hy - 1

      new_tail =
        cond do
          new_hy + 2 == ty && hx == tx ->
            {tx, ty - 1}

          new_hy + 2 == ty && hx < tx ->
            {tx - 1, ty - 1}

          new_hy + 2 == ty && hx > tx ->
            {tx + 1, ty - 1}

          true ->
            {tx, ty}
        end

      [{{hx, new_hy}, new_tail} | acc]
    end)
    |> Enum.take(amount)
    |> Enum.reverse()
  end
end

Day9.part1() |> IO.inspect()
