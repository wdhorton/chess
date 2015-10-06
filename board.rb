require_relative 'piece.rb'
require_relative 'errors.rb'
require 'byebug'

class Board

  def self.new_grid
    Array.new(8) { Array.new(8) }
  end

  attr_reader :grid

  def initialize(grid = Board.new_grid)
    @grid = grid
    populate if pieces.empty?
    pieces.map { |piece| piece.board = self }
  end

  def populate
    [0, 1, 6, 7].each do |row_index|
      if row_index == 1 || row_index == 6
        color = (row_index == 1 ? :black : :white)
        grid[row_index].map!.with_index do |_, col_index|
          Pawn.new(self, [row_index, col_index], color)
        end
      elsif row_index == 0 || row_index == 7
        color = (row_index == 0 ? :black : :white)
        @grid[row_index] =
        [
          Rook.new(self, [row_index, 0], color),
          Knight.new(self, [row_index, 1], color),
          Bishop.new(self, [row_index, 2], color),
          Queen.new(self, [row_index, 3], color),
          King.new(self, [row_index, 4], color),
          Bishop.new(self, [row_index, 5], color),
          Knight.new(self, [row_index, 6], color),
          Rook.new(self, [row_index, 7], color)
        ]
      end
    end
  end

  def pieces(color = nil, type = nil)
    pieces = grid.flatten.reject(&:nil?)
    pieces = pieces.select { |piece| piece.color == color } if color
    pieces = pieces.select { |piece| piece.class == type } if type
    pieces
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    grid[x][y] = value
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]
    message = "Your piece is unable to move to that position"
    raise MoveError.new message unless piece.moves.include?(end_pos)
    message = "You can't leave yourself in check!"
    raise MoveError.new message unless piece.valid_moves.include?(end_pos)
    self[end_pos] = piece
    piece.pos = end_pos
    self[start_pos] = nil
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]
    self[end_pos] = piece
    piece.pos = end_pos
    self[start_pos] = nil
  end

  # board.in_check?(black) # => true or false
  def in_check?(color)
    king_pos = pieces(color, King).first.pos        #
    opposing = pieces(Piece.opponent(color))
    opposing.each do |piece|
      return true if piece.moves.include?(king_pos)
    end

    false
  end

  def checkmate?(color)
    # if checkmate, color == loser
    in_check?(color) && pieces(color).all? { |piece| piece.valid_moves.empty? }
  end

  def dup
    result = Array.new(8) { Array.new(8) }
    grid.each.with_index do |row, x|
      row.each.with_index do |el, y|
        result[x][y] = (el ? el : nil)
      end
    end
    Board.new(result)
  end

  def draw?(color)
    in_check?(color) && pieces(color).all? { |piece| piece.valid_moves.empty? }
  end
end
