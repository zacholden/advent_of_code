defmodule Dial do
  import Integer, only: [mod: 2]
  defstruct history: [50], clicks: 0, size: 100

  def new, do: %Dial{}

  def turn(dial = %Dial{history: [position | _]}, {"L", amount}) do
    {hundreds, remainder} = divmod(amount, dial.size)

    new_position = mod(position - remainder, dial.size)

    hit_zero =
      if position != 0 && (new_position > position || new_position == 0), do: 1, else: 0

    new_clicks = dial.clicks + hundreds + hit_zero

    %{dial | history: [new_position | dial.history], clicks: new_clicks}
  end

  def turn(dial = %Dial{history: [position | _]}, {"R", amount}) do
    {hundreds, remainder} = divmod(amount, dial.size)

    new_position = mod(position + remainder, dial.size)

    hit_zero =
      if position != 0 && (new_position < position || new_position == 0), do: 1, else: 0

    new_clicks = dial.clicks + hundreds + hit_zero

    %{dial | history: [new_position | dial.history], clicks: new_clicks}
  end

  def history(%Dial{history: history}), do: history
  def clicks(%Dial{clicks: clicks}), do: clicks

  defp divmod(a, b) do
    {div(a, b), mod(a, b)}
  end
end

input =
  File.stream!("day01.txt")
  |> Stream.map(fn str -> String.trim(str) |> String.split_at(1) end)
  |> Stream.map(fn {dir, int} -> {dir, String.to_integer(int)} end)

# part 1
Enum.reduce(input, Dial.new(), &Dial.turn(&2, &1))
|> Dial.history()
|> Enum.count(&(&1 == 0))
|> IO.puts()

# part 2
Enum.reduce(input, Dial.new(), &Dial.turn(&2, &1))
|> Dial.clicks()
|> IO.puts()
