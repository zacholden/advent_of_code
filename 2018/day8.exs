defmodule Day8 do
  def part1 do
    File.read!('day8.txt')
    |> String.replace("\n", "")
    |> String.split(" ") 
    |> Enum.map(&String.to_integer/1)
    |> build_node()
    |> sum_metadata()
  end

  def part2 do
    File.read!('day8.txt')
    |> String.replace("\n", "")
    |> String.split(" ") 
    |> Enum.map(&String.to_integer/1)
    |> build_node()
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

  def sum_metadata({tree, list}) do
    sum_metadata(tree, 0)
  end

  defp sum_metadata({children, metadata}, acc) do
    sum_children = Enum.reduce(children, 0, &sum_metadata/2)
    sum_children + Enum.sum(metadata) + acc
  end
end
