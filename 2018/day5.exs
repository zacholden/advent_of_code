defmodule Day5 do
  def part1 do
    File.read!('day5.txt')
    |> String.replace("\n", "")
    |> remove_polymers
  end

  def remove_polymers(string) do
    new_string = reactions(string)
    if String.length(string) == String.length(new_string) do
      String.length(new_string)
    else
      remove_polymers(new_string)
    end
  end

  def part2 do
    File.read!('day5.txt')
    |> String.replace("\n", "")
    |> find_best_sequence
    |> Enum.min
  end

  def find_best_sequence(string) do
    ["a","b","c","d","e","f","g","h","i","j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    |> Enum.map(&test_sequence(&1, string))
  end

  def test_sequence(seq, string) do
    string
    |> String.replace(String.upcase(seq), "")
    |> String.replace(seq, "")
    |> remove_polymers
  end

  def reactions(string) do
    string
    |> String.replace("Aa", "")
    |> String.replace("aA", "")
    |> String.replace("Bb", "")
    |> String.replace("bB", "")
    |> String.replace("Cc", "")
    |> String.replace("cC", "")
    |> String.replace("Dd", "")
    |> String.replace("dD", "")
    |> String.replace("Ee", "")
    |> String.replace("eE", "")
    |> String.replace("Ff", "")
    |> String.replace("fF", "")
    |> String.replace("Gg", "")
    |> String.replace("gG", "")
    |> String.replace("Hh", "")
    |> String.replace("hH", "")
    |> String.replace("Ii", "")
    |> String.replace("iI", "")
    |> String.replace("Jj", "")
    |> String.replace("jJ", "")
    |> String.replace("Kk", "")
    |> String.replace("kK", "")
    |> String.replace("Ll", "")
    |> String.replace("lL", "")
    |> String.replace("Mm", "")
    |> String.replace("mM", "")
    |> String.replace("Nn", "")
    |> String.replace("nN", "")
    |> String.replace("Oo", "")
    |> String.replace("oO", "")
    |> String.replace("Pp", "")
    |> String.replace("pP", "")
    |> String.replace("Qq", "")
    |> String.replace("qQ", "")
    |> String.replace("Rr", "")
    |> String.replace("rR", "")
    |> String.replace("Ss", "")
    |> String.replace("sS", "")
    |> String.replace("Tt", "")
    |> String.replace("tT", "")
    |> String.replace("Uu", "")
    |> String.replace("uU", "")
    |> String.replace("Vv", "")
    |> String.replace("vV", "")
    |> String.replace("Ww", "")
    |> String.replace("wW", "")
    |> String.replace("Xx", "")
    |> String.replace("xX", "")
    |> String.replace("Yy", "")
    |> String.replace("yY", "")
    |> String.replace("Zz", "")
    |> String.replace("zZ", "")
  end
end
