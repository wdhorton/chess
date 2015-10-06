require_relative 'slidingpiece.rb'

class Queen < SlidingPiece
  def move_dirs
    Piece::DIAGONALS + Piece::CROSSES
  end

  def to_s
    super " ♛ "
  end

end
