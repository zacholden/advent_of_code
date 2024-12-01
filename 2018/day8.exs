defmodule Day8 do
  def part1 do
    input() |> build_node() |> sum_metadata()
  end

  def part2 do
    input() |> build_node() |> sum_metadata_with_index()
  end

  def build_node([number_of_children, number_of_metadata | rest]) do
    {children, rest} = children(number_of_children, rest, [])
    {metadata, rest} = Enum.split(rest, number_of_metadata)
    {{children, metadata}, rest}
  end

  def children(0, rest, acc) do
    {Enum.reverse(acc), rest}
  end

  def children(count, rest, acc) do
    {child, rest} = build_node(rest)
    children(count - 1, rest, [child | acc])
  end

  def sum_metadata({tree, _list}) do
    sum_metadata(tree, 0)
  end

  defp sum_metadata({children, metadata}, acc) do
    sum_of_children = Enum.reduce(children, 0, &sum_metadata/2)
    sum_of_children + Enum.sum(metadata) + acc
  end

  defp sum_metadata_with_index({tree, _metadata}) do
    sum_metadata_with_index(tree, 0)
  end

  defp sum_metadata_with_index({children, metadata}, acc) do
    if Enum.empty?(children) do
      acc + Enum.sum(metadata)
    else
      sum_of_children = Enum.reject(metadata, fn i -> i == 0 end)
      |> Enum.map(fn i -> Enum.at(children, i - 1) end)
      |> Enum.reject(&is_nil/1)
      |> Enum.reduce(0, &sum_metadata_with_index/2)

      sum_of_children + acc
    end
  end

  defp input do
    File.read!("day8.txt")
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end

Day8.part1 |> IO.puts
Day8.part2 |> IO.puts
