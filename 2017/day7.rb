class Node
  attr_reader :name, :weight
  attr_accessor :children

  def initialize(name, weight, children)
    @name = name
    @weight = weight
    @children = children
  end

  def get_weight
    return weight if children.empty?

    weight + children.map(&:get_weight).sum
  end
end

class Tree
  attr_reader :root, :nodes
  attr_accessor :source
  def initialize(input = 'day7.txt')
    @source = File
      .read(input)
      .split("\n")
      .map { |str| str.gsub(" ->", "") }
      .map { |str| str.gsub(",", "") }
      .map { |str| str.split(" ") }

    @nodes = build('cyrupz')
  end

  def build(name)
    node = source.find { |arr| arr.first == name }
    binding.pry if !node

    @root = Node.new(node[0], eval(node[1]), node[2..-1].map { |str| build(str) })
  end
end
