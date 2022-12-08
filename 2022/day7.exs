defmodule Day7 do
  @input File.stream!("day7.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(&String.split/1)
         |> Enum.map(&List.to_tuple/1)
  def part1 do
    {file_tree, _state} =
      Enum.reduce(@input, {%{}, []}, fn command, {tree, state} ->
        build_tree(tree, state, command)
      end)

    directory_sizes(file_tree)
    |> Enum.map(fn {_dir, size} -> size end)
    |> Enum.filter(fn size -> 100_000 >= size end)
    |> Enum.sum()
  end

  def part2 do
    {file_tree, _state} =
      Enum.reduce(@input, {%{}, []}, fn command, {tree, state} ->
        build_tree(tree, state, command)
      end)

    total_space = 70_000_000

    used_space = directory_size(file_tree["/"])

    available_space = total_space - used_space

    directory_sizes(file_tree)
    |> Enum.sort_by(fn {_name, size} -> size end)
    |> Enum.find(fn {_name, size} -> size + available_space >= 30_000_000 end)
    |> then(fn {_name, size} -> size end)
  end

  def build_tree(_tree, _state, {"$", "cd", "/"}) do
    {%{"/" => %{}}, ["/"]}
  end

  def build_tree(tree, state, {"$", "cd", ".."}) do
    {_, new_state} = List.pop_at(state, -1)

    {tree, new_state}
  end

  def build_tree(tree, state, {"$", "cd", location}) do
    {tree, state ++ [location]}
  end

  def build_tree(tree, state, {"$", "ls"}), do: {tree, state}

  def build_tree(tree, state, {"dir", dir_name}) do
    new_tree = put_in(tree, state ++ [dir_name], %{})

    {new_tree, state}
  end

  def build_tree(tree, state, {size, name}) do
    new_tree = put_in(tree, state ++ [name], String.to_integer(size))

    {new_tree, state}
  end

  def directory_sizes(tree) do
    {updated_map, _remaining} = Map.pop(tree, "/")

    queue = [updated_map]
    directory_sizes(queue, [{"/", directory_size(updated_map)}])
  end

  def directory_sizes([], scores), do: scores

  def directory_sizes(queue, scores) do
    {updated_queue, updated_scores} =
      Enum.reduce(queue, {[], scores}, fn map, {new_queue, new_scores} ->
        {inner_q, inner_scores} =
          Enum.reduce(map, {[], []}, fn {k, v}, {inner_q, inner_scores} ->
            if is_map(v) do
              {subtree, _remaining} = Map.pop(map, k)

              {[subtree | inner_q], [{k, directory_size(subtree)} | inner_scores]}
            else
              {inner_q, inner_scores}
            end
          end)

        {new_queue ++ inner_q, new_scores ++ inner_scores}
      end)

    directory_sizes(updated_queue, updated_scores)
  end

  def directory_size(map) do
    Enum.reduce(map, 0, fn {_k, v}, acc ->
      if is_map(v) do
        acc + directory_size(v)
      else
        acc + v
      end
    end)
  end
end

Day7.part1() |> IO.inspect()
Day7.part2() |> IO.inspect()
