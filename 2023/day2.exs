input =
  File.read!("day2.txt")
  |> String.replace("Game ", "")
  |> String.split("\n", trim: true)
  |> Enum.map(fn str -> String.split(str, ": ") end)
  |> Enum.map(fn [a, b] ->
    {String.to_integer(a),
     String.split(b, "; ")
     |> Enum.map(fn str ->
       String.split(str, ", ")
       |> Map.new(fn str ->
         String.split(str)
         |> then(fn [amount, color] -> {color, String.to_integer(amount)} end)
       end)
     end)}
  end)

merger = fn left, right -> Map.merge(left, right, fn _k, v1, v2 -> max(v1, v2) end) end

totals = Enum.map(input, fn {k, v} -> {k, Enum.reduce(v, %{}, merger)} end)

# Part 1
limits = %{"red" => 12, "green" => 13, "blue" => 14}

Enum.reject(totals, fn {_k, v} ->
  Enum.any?(v, fn {color, value} -> value > limits[color] end)
end)
|> Enum.reduce(0, fn {k, _cubes}, acc -> acc + k end)
|> IO.inspect()

# Part 2
Enum.reduce(totals, 0, fn {_game_id, cubes}, acc ->
  Map.values(cubes) |> Enum.product() |> Kernel.+(acc)
end)
|> IO.inspect()
