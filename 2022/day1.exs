# Read the file and sum the calories each elf is carrying
calories_per_elf =
  File.read!("day1.txt")
  |> String.split("\n\n")
  |> Enum.map(fn str ->
    String.split(str, "\n", trim: true) |> Enum.map(&String.to_integer/1) |> Enum.sum()
  end)

# Part 1
Enum.max(calories_per_elf)
|> IO.inspect()

# part 2
Enum.sort(calories_per_elf, :desc)
|> Enum.take(3)
|> Enum.sum()
|> IO.inspect()
