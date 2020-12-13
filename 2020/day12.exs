defmodule Day12 do
  @moduledoc """
  There is a ton of repetition here.
  """
  @input File.stream!('day12.txt')
         |> Stream.map(&String.trim/1)
         |> Stream.map(&String.split(&1, "", parts: 2, trim: true))
         |> Stream.map(&List.to_tuple/1)
         |> Enum.map(fn {dir, amount} -> {dir, String.to_integer(amount)} end)
  @orientations %{0 => "N", 1 => "E", 2 => "S", 3 => "W"}
  @number_to_dir %{"N" => 0, "E" => 1, "S" => 2, "W" => 3}
  @waypoint %{"N" => 1, "E" => 10}

  def part1 do
    navigate(@input, 1, 0, 0)
  end

  def part2 do
    navigate_waypoint(@input, @waypoint, 0, 0)
  end

  def navigate_waypoint([head | tail], waypoint, y_pos, x_pos) do
    {waypoint, y_pos, x_pos} = move_waypoint(head, waypoint, y_pos, x_pos)

    navigate_waypoint(tail, waypoint, y_pos, x_pos)
  end

  def navigate_waypoint([], _waypoint, y_pos, x_pos), do: abs(y_pos) + abs(x_pos)

  # rotate the waypoint right
  def move_waypoint({"R", amount}, waypoint, y_pos, x_pos) do
    new_waypoint =
      Enum.reduce(waypoint, %{}, fn {dir, wp_amount}, acc ->
        direction_num = Map.get(@number_to_dir, dir)
        turning_amount = div(amount, 90)

        new_dir_num = rem(direction_num + turning_amount, 4)
        new_dir = Map.get(@orientations, new_dir_num)

        Map.put(acc, new_dir, wp_amount)
      end)

    {new_waypoint, y_pos, x_pos}
  end

  # rotate the waypoint left
  def move_waypoint({"L", amount}, waypoint, y_pos, x_pos) do
    new_waypoint =
      Enum.reduce(waypoint, %{}, fn {dir, wp_amount}, acc ->
        direction_num = Map.get(@number_to_dir, dir)
        turning_amount = div(amount, 90)

        new_dir_num = rem(direction_num - turning_amount + 4, 4)
        new_dir = Map.get(@orientations, new_dir_num)

        Map.put(acc, new_dir, wp_amount)
      end)

    {new_waypoint, y_pos, x_pos}
  end

  def move_waypoint({"F", amount}, waypoint, y_pos, x_pos) do
    {new_y, new_x} =
      Enum.reduce(waypoint, {y_pos, x_pos}, fn {dir, wp_amount}, {y_pos, x_pos} ->
        case dir do
          "N" ->
            {y_pos + wp_amount * amount, x_pos}

          "E" ->
            {y_pos, x_pos + wp_amount * amount}

          "S" ->
            {y_pos - wp_amount * amount, x_pos}

          "W" ->
            {y_pos, x_pos - wp_amount * amount}
        end
      end)

    {waypoint, new_y, new_x}
  end

  def move_waypoint({key, amount}, waypoint, y_pos, x_pos) do
    new_wp =
      case key do
        "N" ->
          if Map.has_key?(waypoint, key) do
            Map.update!(waypoint, key, &(&1 + amount))
          else
            Map.update!(waypoint, "S", &(&1 - amount))
          end

        "E" ->
          if Map.has_key?(waypoint, key) do
            Map.update!(waypoint, key, &(&1 + amount))
          else
            Map.update!(waypoint, "W", &(&1 - amount))
          end

        "S" ->
          if Map.has_key?(waypoint, key) do
            Map.update!(waypoint, key, &(&1 + amount))
          else
            Map.update!(waypoint, "N", &(&1 - amount))
          end

        "W" ->
          if Map.has_key?(waypoint, key) do
            Map.update!(waypoint, key, &(&1 + amount))
          else
            Map.update!(waypoint, "E", &(&1 - amount))
          end
      end

    {new_wp, y_pos, x_pos}
  end

  def navigate([head | tail], orientation, y_pos, x_pos) do
    {orientation, y_pos, x_pos} = move(head, orientation, y_pos, x_pos)

    navigate(tail, orientation, y_pos, x_pos)
  end

  def navigate([], _orientation, y_pos, x_pos) do
    abs(y_pos) + abs(x_pos)
  end

  defp move({"N", amount}, orientation, y_pos, x_pos), do: {orientation, y_pos + amount, x_pos}
  defp move({"E", amount}, orientation, y_pos, x_pos), do: {orientation, y_pos, x_pos + amount}
  defp move({"S", amount}, orientation, y_pos, x_pos), do: {orientation, y_pos - amount, x_pos}
  defp move({"W", amount}, orientation, y_pos, x_pos), do: {orientation, y_pos, x_pos - amount}

  defp move({"F", amount}, orientation, y_pos, x_pos) do
    case Map.get(@orientations, orientation) do
      "N" ->
        {orientation, y_pos + amount, x_pos}

      "E" ->
        {orientation, y_pos, x_pos + amount}

      "S" ->
        {orientation, y_pos - amount, x_pos}

      "W" ->
        {orientation, y_pos, x_pos - amount}
    end
  end

  defp move({"R", amount}, orientation, y_pos, x_pos) do
    turning_amount = div(amount, 90)

    {rem(orientation + turning_amount, 4), y_pos, x_pos}
  end

  defp move({"L", amount}, orientation, y_pos, x_pos) do
    turning_amount = div(amount, 90)

    {rem(orientation - turning_amount + 4, 4), y_pos, x_pos}
  end
end

Day12.part1() |> IO.puts()
Day12.part2() |> IO.puts()
