defmodule Day13 do
  @input File.read!("day13.txt")
         |> String.split("\n\n", trim: true)
         |> Enum.flat_map(fn str -> String.split(str, "\n", trim: true) end)
         |> Enum.map(&Code.eval_string/1)
         |> Enum.map(fn {list, []} -> list end)
         |> Enum.chunk_every(2)
         |> Enum.map(fn [list1, list2] -> {list1, list2} end)

  def part1 do
    Enum.with_index(@input, 1)
    |> Enum.map(fn {{left, right}, idx} ->
      {compare(left, right), idx}
    end)
    |> Enum.filter(fn {bool, _idx} ->
      bool
    end)
    |> Enum.map(fn {_bool, idx} -> idx end)
    |> Enum.sum()
  end

  def part2 do
    divider_packets = [[[2]], [[6]]]

    Enum.flat_map(@input, fn {left, right} -> [left, right] end)
    |> Kernel.++(divider_packets)
    |> Enum.sort(&compare/2)
    |> Enum.with_index(1)
    |> Enum.filter(fn {packet, _idx} -> packet in divider_packets end)
    |> Enum.map(fn {_packet, idx} -> idx end)
    |> Enum.product()
  end

  # One is integer other is list
  defp compare(left, right) when is_integer(left) and is_list(right), do: compare([left], right)
  defp compare(left, right) when is_integer(right) and is_list(left), do: compare(left, [right])

  defp compare([lh | _lt], [rh | _rt]) when is_integer(lh) and is_integer(rh) and lh > rh,
    do: false

  defp compare([lh | _lt], [rh | _rt]) when is_integer(lh) and is_integer(rh) and lh < rh,
    do: true

  defp compare([lh | lt], [rh | rt]) when is_integer(lh) and is_integer(rh) and lh == rh,
    do: compare(lt, rt)

  defp compare([], []), do: nil
  defp compare(left, []) when length(left) > 0, do: false
  defp compare([], right) when length(right) > 0, do: true

  defp compare([], [_right]), do: true

  defp compare([lh | lt], [rh | rt]) when is_list(lh) and is_list(rh) do
    case compare(lh, rh) do
      true -> true
      false -> false
      _ -> compare(lt, rt)
    end
  end

  defp compare([lh | []], [rh | rt]) when is_integer(lh) do
    case compare([lh], rh) do
      true -> true
      false -> false
      _ -> compare([], rt)
    end
  end

  defp compare([lh | lt], [rh | []]) when is_integer(rh) do
    case compare(lh, [rh]) do
      true -> true
      false -> false
      _ -> compare(lt, [])
    end
  end

  defp compare([lh | lt], [rh | rt]) when is_integer(rh) do
    case compare(lh, [rh]) do
      true -> true
      false -> false
      _ -> compare(lt, rt)
    end
  end

  defp compare([lh | lt], [rh | rt]) when is_integer(lh) do
    case compare(lh, [rh]) do
      true -> true
      false -> false
      _ -> compare(lt, rt)
    end
  end
end

Day13.part1() |> IO.inspect()
Day13.part2() |> IO.inspect()
