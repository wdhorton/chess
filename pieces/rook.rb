require_relative 'slidingpiece.rb'

class Rook < SlidingPiece

  attr_accessor :moved

  def initialize(board, pos, color)
    super
    @moved = false
  end

  # def castle
  #   options = []
  #   x, y = pos
  #   if !moved
  #     king = board.pieces(color, King)[0]
  #     options << [x, y + 2] if !king.moved && pos.last == 0
  #     options << [x, y - 2] if !king.moved && pos.last == 7
  #   end
  #
  #   options
  # end

  def move_dirs
    Piece::CROSSES
  end

  def to_s
    super " ♜ "
  end

end
