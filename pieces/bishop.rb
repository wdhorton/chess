require_relative 'slidingpiece.rb'

class Bishop < SlidingPiece
  def move_dirs
    Piece::DIAGONALS
  end

  def to_s
    super " ♝ "
  end

end
