defmodule Day9 do
  @input File.stream!("day9.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(&String.split/1)
         |> Stream.map(fn [dir, amount] -> String.duplicate(dir, String.to_integer(amount)) end)
         |> Enum.flat_map(&String.codepoints/1)

  def part1 do
    knots = [Enum.map(0..1, fn _ -> {0, 0} end)]

    Enum.reduce(@input, knots, fn dir, acc ->
      [{x, y} | rest] = hd(acc)

      head = move(dir, {x, y})

      [propogate(rest, [head]) | acc]
    end)
    |> Enum.map(&List.last/1)
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2 do
    knots = [Enum.map(0..9, fn _ -> {0, 0} end)]

    Enum.reduce(@input, knots, fn dir, acc ->
      [{x, y} | rest] = hd(acc)

      head = move(dir, {x, y})

      [propogate(rest, [head]) | acc]
    end)
    |> Enum.map(&List.last/1)
    |> Enum.uniq()
    |> Enum.count()
  end

  def propogate([], result), do: Enum.reverse(result)

  # There are 18 options of where the knot you are following could be because the knots can move diagonally
  # to follow the head, in the cond they start from directy two squares above and move clockwise
  def propogate([{tx, ty} | rest], result) do
    {hx, hy} = hd(result)

    new_tail = follow({hx, hy}, {tx, ty})

    propogate(rest, [new_tail | result])
  end

  def move("U", {x, y}), do: {x, y + 1}
  def move("R", {x, y}), do: {x + 1, y}
  def move("L", {x, y}), do: {x - 1, y}
  def move("D", {x, y}), do: {x, y - 1}

  def follow({hx, hy}, {tx, ty}) do
    cond do
      hx == tx && hy - 2 == ty ->
        # up
        {tx, ty + 1}

      (hx > tx && hy - 2 == ty) || (hx - 2 == tx && hy > ty) ->
        # right up
        {tx + 1, ty + 1}

      hx - 2 == tx && hy == ty ->
        # right
        {tx + 1, ty}

      (hx - 2 == tx && hy < ty) || (hx > tx && hy + 2 == ty) ->
        # right down
        {tx + 1, ty - 1}

      hx == tx && hy + 2 == ty ->
        # down
        {tx, ty - 1}

      (hx < tx && hy + 2 == ty) || (hx + 2 == tx && hy < ty) ->
        # left down
        {tx - 1, ty - 1}

      hx + 2 == tx && hy == ty ->
        # left
        {tx - 1, ty}

      (hx + 2 == tx && hy > ty) || (hx < tx && hy - 2 == ty) ->
        # up left
        {tx - 1, ty + 1}

      true ->
        {tx, ty}
    end
  end
end

Day9.part1() |> IO.inspect()
Day9.part2() |> IO.inspect()
