defmodule Coprocessor do
  def evaluate do
    read_file
  end

  defp read_file do
    { :ok, result } = File.read("day23.txt")

    result
    |> String.split("\n", trim: true) 
    |> Enum.map(fn str -> String.split(str, " ") end)
  end
end
