class Node
  attr_reader :name, :weight, :subweights
  attr_accessor :children

  def initialize(name, weight, children)
    @name = name
    @weight = weight
    @children = children
  end

  def subweights
    return weight if children.empty?

    @subweights ||= weight + children.map(&:subweights).sum
  end

  def misweighted_child
    misweight = children.map(&:subweights).tally.find { |k,v| v == 1 }.first

    children.find { |child| child.subweights == misweight }
  end

  def find_misweighted_child
    parent = self

    loop do
      child = parent.misweighted_child

      if child.children.map(&:subweights).uniq.size == 1
        child_subweight = child.subweights
        other_child_subweights = parent.children.map(&:subweights).find { |sw| sw != child_subweight }

        diff = other_child_subweights - child_subweight

        break child.weight + diff
      end

      parent = child
    end
  end
end

nodes = File.read("day07.txt")
  .split("\n")
  .map { |str| str.gsub(/ ->|,|\(|\)/, "") }
  .map(&:split)
  .map { |arr| [arr[0], arr[1].to_i, arr[2..]] }

root = nodes.find { |n| nodes.none? { |n2| n2[2].include?(n.first) } }

# part 1
puts root.first

def build(name, nodes)
  node = nodes.find { |n| name == n[0] }

  Node.new(node[0], node[1], node[2].map { |name| build(name, nodes) })
end

tree = build(root.first, nodes)

# part 2
puts tree.find_misweighted_child
