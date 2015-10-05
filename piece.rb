
class Piece
  attr_accessor :pos
  attr_reader :board, :color

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
  end

  def moves
  end

  def valid_moves
    moves.reject { |move| move_into_check?(move) }
  end

  def move_into_check?(ending_pos)
    dupped_board = board.dup
    dupped_board.move!(pos, ending_pos)
    dupped_board.in_check?(color)
  end

  def to_s(letter)
    letter.colorize(color)
  end

end

class SlidingPiece < Piece
  def moves
    result = []
    move_dirs.each do |dx, dy|
      a = pos
      a = [a[0] + dx, a[1] + dy]
      until !a[0].between?(0,7) || !a[1].between?(0,7) || board[a]
        result << a
        a = [a[0] + dx, a[1] + dy]
      end

      result << a if a[0].between?(0,7) && a[1].between?(0,7) && board[a].color != color
    end

    result
  end
end

class SteppingPiece < Piece
  def moves
    result = []
    move_dirs.each do |dx, dy|
      new_pos = [pos[0] + dx, pos[1] + dy]
      result << new_pos if new_pos.all? { |x| x.between?(0, 7) }
    end

    result
  end
end

class Bishop < SlidingPiece
  def move_dirs
    moves = [ [1, 1], [-1, -1], [1, -1], [-1, 1] ]
  end

  def to_s
    super "B"
  end

end

class Rook < SlidingPiece
  def move_dirs
    moves = [ [1, 0], [0, 1], [-1, 0], [0, -1] ]
  end

  def to_s
    super "R"
  end

end

class Queen < SlidingPiece
  def move_dirs
    moves = [ [1, 0], [0, 1], [-1, 0], [0, -1],
    [1, 1], [-1, -1], [1, -1], [-1, 1] ]
  end

  def to_s
    super "Q"
  end

end

class Knight < SteppingPiece
  def move_dirs
    moves = [ [2, 1], [1, 2], [2, -1], [1, -2],
      [-2, -1], [-2, 1], [-1, 2], [-1, -2] ]
  end

  def to_s
    super "N"
  end

end

class King < SteppingPiece
  def move_dirs
    moves = [ [1, 0], [0, 1], [-1, 0], [0, -1],
    [1, 1], [-1, -1], [1, -1], [-1, 1] ]
  end

  def to_s
    super "K"
  end

end

class Pawn < Piece
  def initialize(board, pos, color)
    super(board, pos, color)
    @starting_pos = pos
  end

  def direction
    @starting_pos[0] == 1 ? :down : :up
  end

  def moves
    result = []
    if direction == :up
       result << [ pos[0] - 1, pos[1]]
       result << [ pos[0] - 2, pos[1]] if pos == @starting_pos
     else
       result << [pos[0] + 1, pos[1]]
       result << [pos[0] + 2, pos[1]] if pos == @starting_pos
     end
     result
  end

  def to_s
    super "P"
  end


end
