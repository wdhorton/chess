require_relative 'steppingpiece.rb'

class Knight < SteppingPiece
  def move_dirs
    moves = [ [2, 1], [1, 2], [2, -1], [1, -2],
      [-2, -1], [-2, 1], [-1, 2], [-1, -2] ]
  end

  def to_s
    super " ♞ "
  end

end
