defmodule Duet do
  def sing do
  end

  def read_file do
    { :ok, text } = File.read("day18.txt")
    text
    |> String.split("\n", trim: true)
    |> Enum.map(fn str -> String.split(str, " ") end)
  end
end
