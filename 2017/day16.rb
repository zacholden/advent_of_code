class Dancer
  attr_reader :moves, :body

  def initialize(moves, body)
    @moves = moves
    @body = body
  end

  def dance
    moves.each { |move| self.send(move.first, move.last) }
    body
  end

  def s(args)
    @body.rotate!(@body.length - args.first.to_i)
  end

  def x(args)
    a, b = args.first.to_i, args.last.to_i
    @body[a], @body[b] = @body[b], @body[a]
  end

  def p(args)
    x([@body.index(args.first), @body.index(args.last)])
  end
end

