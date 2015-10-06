class Piece
  DIAGONALS = [ [1, 1], [-1, -1], [1, -1], [-1, 1] ]
  CROSSES = [ [1, 0], [0, 1], [-1, 0], [0, -1] ]

  def self.opponent(color)
    color == :white ? :black : :white
  end

  attr_accessor :board, :pos
  attr_reader :color

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @board[pos] = self
    @color = color
  end

  def moves
    raise NotImplementedError
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

  def on_board?(pos)
    pos[0].between?(0,7) && pos[1].between?(0,7)
  end

  def empty?(pos)
    board[pos].nil?
  end

  def opponent_there?(pos)
    board[pos].color != color
  end

end
