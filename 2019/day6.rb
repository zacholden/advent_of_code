require 'pry'

class Node
  attr_reader :name, :children
  def initialize(name, children)
    @name = name
    @children = children || []
  end

  def orbits(total = 0)
    return total if children.empty?

    total + children.map { |child| child.orbits(total + 1) }.sum
  end

  def search(target, map = {})
    return map if name == target
    return if children.empty?

    children.map { |child| child.search(target, map.merge(name => child.name)) }.flatten.compact.first
  end
end

class Tree
  attr_reader :source, :root
  def initialize
    @source = File.read('day6.txt').split("\n").map { |str| str.split(')') }
  end

  def insert(name)
    entries = source.select { |arr| arr.first == name }.map(&:last)

    @root = Node.new(name, entries.map { |entry| insert(entry) })
  end
end

tree = Tree.new
tree.insert('COM')
puts tree.root.orbits
you = tree.root.search('YOU')
san = tree.root.search('SAN')
shared_parent = (san.keys & you.keys).last
san_traversals = san.keys.index(san.keys.last) - san.keys.index(shared_parent)
you_traversals = you.keys.index(you.keys.last) - you.keys.index(shared_parent)
puts (you_traversals + san_traversals)
