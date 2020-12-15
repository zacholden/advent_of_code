defmodule Day14 do
  @input File.stream!('day14.txt') |> Enum.map(&String.trim/1)
  def part1 do
    process_instruction(@input, %{}, %{})
  end

  def part2 do
    process_instruction_floating(@input, %{}, %{})
  end

  def process_instruction_floating([head | tail], memory, mask) do
    if String.contains?(head, "mask") do
      process_instruction_floating(tail, memory, update_mask_floating(head))
    else
      process_instruction_floating(tail, write_memory_floating(head, memory, mask), mask)
    end
  end

  def process_instruction_floating([], memory, _mask) do
    Enum.reduce(memory, 0, fn {_k, v}, acc -> v + acc end)
  end

  def process_instruction([head | tail], memory, mask) do
    if String.contains?(head, "mask") do
      process_instruction(tail, memory, update_mask(head))
    else
      process_instruction(tail, write_memory(head, memory, mask), mask)
    end
  end

  def process_instruction([], memory, _mask) do
    Enum.reduce(memory, 0, fn {_k, v}, acc -> v + acc end)
  end

  def write_memory_floating(instruction, memory, mask) do
    value = instruction |> String.split(" = ") |> List.last() |> String.to_integer()

    floating_addresses(instruction, mask)
    |> Enum.reduce(memory, fn address, acc -> Map.put(acc, address, value) end)
  end

  def floating_addresses(instruction, mask) do
    value =
      instruction
      |> String.replace("mem[", "")
      |> String.split("]")
      |> hd
      |> String.to_integer()
      |> Integer.to_string(2)
      |> String.pad_leading(36, "0")
      |> binary_to_map

    result = Map.merge(value, mask)
    floating_bits = Enum.filter(result, fn {_k, v} -> v == "X" end)
    number_of_floating_bits = floating_bits |> Enum.count()
    order = (:math.pow(2, number_of_floating_bits) |> round) - 1

    list_of_replacements =
      0..order
      |> Enum.map(fn int ->
        Integer.to_string(int, 2) |> String.pad_leading(number_of_floating_bits, "0")
      end)
      |> Enum.map(&String.codepoints/1)

    Enum.map(list_of_replacements, fn list -> swap_floats(list, result) end)
  end

  def swap_floats(list, result) do
    swapped_memory =
      result
      |> Enum.filter(fn {_, v} -> v == "X" end)
      |> Enum.zip(list)
      |> Enum.map(fn {{k, _v}, replacement} -> {k, replacement} end)
      |> Enum.into(%{})

    Map.merge(result, swapped_memory) |> map_to_binary |> String.to_integer(2)
  end

  def write_memory(instruction, memory, mask) do
    {address, binary_map} = parse_instruction(instruction)

    value = Map.merge(binary_map, mask) |> map_to_binary |> String.to_integer(2)

    Map.put(memory, address, value)
  end

  def update_mask(mask) do
    mask |> String.replace("mask = ", "") |> binary_to_map
  end

  def update_mask_floating(mask) do
    mask |> String.replace("mask = ", "") |> binary_to_floating_map
  end

  def binary_to_floating_map(string) do
    string
    |> String.reverse()
    |> String.graphemes()
    |> Stream.with_index()
    |> Stream.filter(fn {str, _idx} -> str != "0" end)
    |> Enum.into(%{}, fn {str, idx} -> {idx, str} end)
  end

  def binary_to_map(string) do
    string
    |> String.reverse()
    |> String.graphemes()
    |> Stream.with_index()
    |> Stream.filter(fn {str, _idx} -> str != "X" end)
    |> Enum.into(%{}, fn {str, idx} -> {idx, str} end)
  end

  def parse_instruction(instruction) do
    address =
      instruction |> String.replace("mem[", "") |> String.split("]") |> hd |> String.to_integer()

    binary_map =
      instruction
      |> String.split(" = ")
      |> List.last()
      |> String.to_integer()
      |> Integer.to_string(2)
      |> String.pad_leading(36, "0")
      |> binary_to_map

    {address, binary_map}
  end

  def map_to_binary(map) do
    map |> Enum.sort() |> List.foldr("", fn {_k, v}, acc -> acc <> v end)
  end
end

Day14.part1() |> IO.puts()
Day14.part2() |> IO.puts()
