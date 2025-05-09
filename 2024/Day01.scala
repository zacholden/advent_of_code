object Day01:
  @main def main: Unit =
    val input = parse()
    println(part1(input))
    println(part2(input))

  def parse(): (Seq[Int], Seq[Int]) =
    val lines = io.Source.fromFile("day01.txt").getLines.toSeq
    val linesSeq: Seq[(Int, Int)] = lines.map:
      case s"$a   $b" => (a.toInt, b.toInt)

    linesSeq.unzip

  def part1(lists: (Seq[Int], Seq[Int])): Int =
    val left = lists(0).sorted
    val right = lists(1).sorted

    left.zip(right).map((l, r) => math.abs(l - r)).sum

  def part2(lists: (Seq[Int], Seq[Int])): Int =
    val left = lists(0)
    val frequencies = lists(1).groupBy(identity).view.mapValues(_.size)

    left.fold(0): (acc, i) =>
      acc + (i * frequencies.getOrElse(i, 0))
