require_relative 'steppingpiece.rb'

class King < SteppingPiece
  attr_accessor :moved

  def initialize(board, pos, color)
    super
    @moved = false
  end

  def castle
    options = []
    x, y = pos
    if !moved
      rook1 = board.pieces(color, Rook).select { |piece| piece.pos.last == 0 }[0]
      rook2 = board.pieces(color, Rook).select { |piece| piece.pos.last == 7 }[0]
      options << [0, 2] if rook2 && !rook2.moved
      options << [0, -2] if rook1 && !rook1.moved
    end
    options
  end

  def move_dirs
    Piece::DIAGONALS + Piece::CROSSES + castle
  end

  def to_s
    super " ♚ "
  end

end
