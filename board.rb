require_relative './pieces/bishop.rb'
require_relative './pieces/king.rb'
require_relative './pieces/knight.rb'
require_relative './pieces/pawn.rb'
require_relative './pieces/queen.rb'
require_relative './pieces/rook.rb'
require_relative './pieces/piece.rb'
require_relative 'errors.rb'
require 'byebug'

class Board

  def self.new_grid
    Array.new(8) { Array.new(8) }
  end

  attr_reader :grid


  def initialize(fill)
    @grid = Board.new_grid
    populate if fill
  end

  def populate
    [0, 1, 6, 7].each do |row_index|
      if row_index == 1 || row_index == 6
        color = (row_index == 1 ? :black : :white)
        (0..7).each do |col_index|
          Pawn.new(self, [row_index, col_index], color)
        end
      elsif row_index == 0 || row_index == 7
        color = (row_index == 0 ? :black : :white)
        Rook.new(self, [row_index, 0], color)
        Knight.new(self, [row_index, 1], color)
        Bishop.new(self, [row_index, 2], color)
        Queen.new(self, [row_index, 3], color)
        King.new(self, [row_index, 4], color)
        Bishop.new(self, [row_index, 5], color)
        Knight.new(self, [row_index, 6], color)
        Rook.new(self, [row_index, 7], color)
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
    if piece.class == King && !piece.castle.empty?
      x, y = end_pos
      if y == 2
        rook = self[[x, y - 2]]    #save rook as variable 'rook'
        self[[x, y + 1]] = rook
        rook.pos = [x, y + 1]
        self[[x, y - 2]] = nil
      elsif y == 6
        rook = self[[x, y + 1]]    #save rook as variable 'rook'
        self[[x, y - 1]] = rook
        rook.pos = [x, y - 1]
        self[[x, y + 1]] = nil
      end
    end
    piece.moved = true if piece.class == King || piece.class == Rook
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
    new_board = Board.new(false)
    pieces.each { |piece| piece.class.new(new_board, piece.pos, piece.color) }
    new_board
  end

  def draw?(color)
    in_check?(color) && pieces(color).all? { |piece| piece.valid_moves.empty? }
  end
end
