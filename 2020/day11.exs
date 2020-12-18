defmodule Day11 do
  @grid File.stream!('day11.txt')
        |> Stream.map(&String.trim/1)
        |> Stream.map(&String.codepoints/1)
        |> Stream.map(&Enum.with_index/1)
        |> Stream.with_index()
        |> Stream.flat_map(fn {list, y_index} ->
          Enum.map(list, fn {value, x_index} -> {{y_index, x_index}, value} end)
        end)
        |> Enum.into(%{})
  @grid_length @grid |> Map.keys() |> Enum.max() |> elem(0)
  @grid_width @grid |> Map.keys() |> Enum.max() |> elem(1)
  @neighbours_map %{"L" => 0, "." => 0, "#" => 0}

  def part1 do
    tick(@grid)
  end

  def part2 do
    tick_los(@grid)
  end

  def tick(grid) when is_map(grid) do
    new_grid =
      Stream.map(grid, fn {coords, value} -> {coords, change(grid, coords, value)} end)
      |> Enum.into(%{})

    # print(grid)
    # IO.puts("\n")

    if new_grid != grid do
      tick(new_grid)
    else
      tick(Map.values(new_grid))
    end
  end

  def tick(grid) when is_list(grid) do
    grid |> Stream.filter(&(&1 == "#")) |> Enum.count()
  end

  def tick_los(grid) when is_map(grid) do
    new_grid =
      Stream.map(grid, fn {coords, value} -> {coords, change_los(grid, coords, value)} end)
      |> Enum.into(%{})

    #print(grid)
    #IO.puts("\n")

    if new_grid != grid do
      tick_los(new_grid)
    else
      tick_los(Map.values(new_grid))
    end
  end

  def tick_los(grid) when is_list(grid) do
    grid |> Stream.filter(&(&1 == "#")) |> Enum.count()
  end

  def change(grid, {y, x}, value) do
    neighbours =
      [
        {y - 1, x - 1},
        {y - 1, x},
        {y - 1, x + 1},
        {y, x + 1},
        {y + 1, x + 1},
        {y + 1, x},
        {y + 1, x - 1},
        {y, x - 1}
      ]
      |> Enum.reduce(@neighbours_map, fn coords, acc ->
        Map.update(acc, Map.get(grid, coords), 0, fn default -> default + 1 end)
      end)

    case value do
      "L" ->
        if Map.get(neighbours, "#") == 0 do
          "#"
        else
          "L"
        end

      "#" ->
        if Map.get(neighbours, "#") > 3 do
          "L"
        else
          "#"
        end

      "." ->
        "."
    end
  end

  def change_los(grid, {y, x}, value) do
    neighbours = find_los_neighbours(grid, {y, x})
                 |> Enum.reduce(@neighbours_map, fn str, acc ->
                   Map.update(acc, str, 0, fn default -> default + 1 end)
                 end)

    case value do
      "L" ->
        if Map.get(neighbours, "#") == 0 do
          "#"
        else
          "L"
        end

      "#" ->
        if Map.get(neighbours, "#") > 4 do
          "L"
        else
          "#"
        end

      "." ->
        "."
    end
  end

  def find_los_neighbours(grid, {y, x}) do
    [
      {-1, -1},
      {-1, 0},
      {-1, 1},
      {0, 1},
      {1, 1},
      {1, 0},
      {1, -1},
      {0, -1}
    ]
    |> Enum.map(fn {dir_y, dir_x} -> find_los_neighbour(grid, {y, x}, dir_y, dir_x) end)
  end

  def find_los_neighbour(grid, {y, x}, dir_y, dir_x) do
    new_y = y + dir_y
    new_x = x + dir_x

    case Map.get(grid, {new_y, new_x}) do
      "#" ->
        "#" 

      "L" ->
        "L"

      "." ->
        find_los_neighbour(grid, {new_y, new_x}, dir_y, dir_x)

      nil ->
        "."
    end
  end

  def print(grid) do
    for row <- 0..@grid_length do
      for col <- 0..@grid_width do
        Map.get(grid, {row, col})
      end
      |> Enum.join("")
    end
    |> Enum.join("\n")
    |> IO.puts()
  end
end

#Day11.part1() |> IO.puts()
Day11.part2() |> IO.puts()
