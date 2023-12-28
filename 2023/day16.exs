defmodule Day16 do
  def part1 do
    grid = input()

    start = [{{0, 0}, :right}]

    run(grid, MapSet.new(), start)
  end

  def part2 do
    grid = input()

    keys = Map.keys(grid)

    {min_x, max_x} = Enum.map(keys, fn {x, _y} -> x end) |> Enum.min_max()
    {min_y, max_y} = Enum.map(keys, fn {_x, y} -> y end) |> Enum.min_max()

    lefts =
      Enum.filter(keys, fn {x, _y} -> x == min_x end)
      |> Enum.map(fn coord -> {coord, :right} end)

    tops =
      Enum.filter(keys, fn {_x, y} -> y == min_y end)
      |> Enum.map(fn coord -> {coord, :down} end)

    rights =
      Enum.filter(keys, fn {x, _y} -> x == max_x end)
      |> Enum.map(fn coord -> {coord, :left} end)

    bottoms =
      Enum.filter(keys, fn {_x, y} -> y == max_y end) |> Enum.map(fn coord -> {coord, :up} end)

    List.flatten([lefts, rights, bottoms, tops])
    |> Enum.map(fn laser -> run(grid, MapSet.new(), [laser]) end)
    |> Enum.max()
  end

  def run(grid, visited, lasers) do
    {new_visited, new_lasers} =
      Enum.reduce(lasers, {visited, []}, fn {{x, y}, _dir} = laser, {visited, lasers_acc} ->
        moves = move(grid[{x, y}], laser)

        new_moves =
          case moves do
            [a, b] -> [a, b | lasers_acc]
            [a] -> [a | lasers_acc]
            [] -> lasers_acc
          end
          |> Enum.reject(fn move -> MapSet.member?(visited, move) end)

        new_set = if Map.has_key?(grid, {x, y}), do: MapSet.put(visited, laser), else: visited

        {new_set, new_moves}
      end)

    if new_visited != visited do
      run(grid, new_visited, new_lasers)
    else
      MapSet.new(visited, fn {a, _b} -> a end) |> MapSet.size()
    end
  end

  def move("/", {{x, y}, dir}) do
    case dir do
      :up ->
        [{{x + 1, y}, :right}]

      :right ->
        [{{x, y - 1}, :up}]

      :left ->
        [{{x, y + 1}, :down}]

      :down ->
        [{{x - 1, y}, :left}]
    end
  end

  def move("\\", {{x, y}, dir}) do
    case dir do
      :up ->
        [{{x - 1, y}, :left}]

      :right ->
        [{{x, y + 1}, :down}]

      :left ->
        [{{x, y - 1}, :up}]

      :down ->
        [{{x + 1, y}, :right}]
    end
  end

  def move("-", {{x, y}, dir}) do
    case dir do
      :up ->
        [{{x + 1, y}, :right}, {{x - 1, y}, :left}]

      :right ->
        [{{x + 1, y}, dir}]

      :left ->
        [{{x - 1, y}, dir}]

      :down ->
        [{{x - 1, y}, :left}, {{x + 1, y}, :right}]
    end
  end

  def move("|", {{x, y}, dir}) do
    case dir do
      :up ->
        [{{x, y - 1}, dir}]

      :right ->
        [{{x, y - 1}, :up}, {{x, y + 1}, :down}]

      :left ->
        [{{x, y + 1}, :down}, {{x, y - 1}, :up}]

      :down ->
        [{{x, y + 1}, dir}]
    end
  end

  def move(".", {{x, y}, dir}) do
    case dir do
      :up ->
        [{{x, y - 1}, dir}]

      :right ->
        [{{x + 1, y}, dir}]

      :left ->
        [{{x - 1, y}, dir}]

      :down ->
        [{{x, y + 1}, dir}]
    end
  end

  def move(nil, _), do: []

  def input(filename \\ "day16.txt") do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {str, y_idx}, acc ->
      String.codepoints(str)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {char, x_idx}, inner_acc ->
        Map.put(inner_acc, {x_idx, y_idx}, char)
      end)
      |> Map.merge(acc)
    end)
  end

  def draw(grid) do
    {min_x, max_x} = Map.keys(grid) |> Enum.map(fn {x, _y} -> x end) |> Enum.min_max()
    {min_y, max_y} = Map.keys(grid) |> Enum.map(fn {_x, y} -> y end) |> Enum.min_max()

    for(x <- min_x..max_x, y <- min_y..max_y, do: {x, y})
    |> Enum.sort_by(fn {_x, y} -> y end)
    |> Enum.chunk_every(max_x + 1)
    |> Enum.map_join("\n", fn list ->
      Enum.map_join(list, fn coord -> Map.get(grid, coord, ".") end)
    end)
    |> IO.puts()
  end
end

Day16.part1() |> IO.inspect()
Day16.part2() |> IO.inspect()
