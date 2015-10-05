require_relative 'piece.rb'
require_relative 'errors.rb'
require 'byebug'

class Board

  attr_reader :grid

  def initialize(grid = nil)
    grid ||= Array.new(8) do |i|
      if i == 1 || i == 6
        color = (i == 1 ? :black : :white)
        (0..7).inject([]) {|acc, j | acc << Pawn.new(self, [i, j], color)}
      elsif i == 0 || i == 7
        color = (i == 0 ? :black : :white)
        [Rook.new(self, [i, 0], color), Knight.new(self, [i, 1], color), Bishop.new(self, [i, 2], color),
        Queen.new(self, [i, 3], color), King.new(self, [i, 4], color), Bishop.new(self, [i, 5], color),
        Knight.new(self, [i, 6], color), Rook.new(self, [i, 7], color)]
      else
        Array.new(8)
      end
    end

    @grid = grid
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
    raise MoveError.new "No piece is at that starting position" if piece.nil?
    raise MoveError.new "Your piece is unable to move to that position" unless piece.moves.include?(end_pos)
    raise MoveError.new "You can't leave yourself in check!" unless piece.valid_moves.include?(end_pos)
    self[end_pos] = piece
    piece.pos = end_pos
    self[start_pos] = nil
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]
    raise MoveError.new "No piece is at that starting position" if piece.nil?
    raise MoveError.new "Your piece is unable to move to that position" unless piece.moves.include?(end_pos)
    self[end_pos] = piece
    piece.pos = end_pos
    self[start_pos] = nil
  end

  # board.in_check?(black) # => true or false
  def in_check?(color)
    king_pos = grid.flatten.reject(&:nil?).select { |piece| piece.class == King && piece.color == color }.first.pos
    opposing = grid.flatten.reject(&:nil?).select { |piece| piece.color != color }
    opposing.each do |piece|
      return true if piece.moves.include?(king_pos)
    end

    false
  end

  def checkmate?(color)
    pieces = grid.flatten.reject(&:nil?).select { |piece| piece.color == color }
    in_check?(color) && pieces.all? { |piece| piece.valid_moves.empty? }
  end

  def dup
    result = Array.new(8) { Array.new(8) }
    grid.each.with_index do |row, x|
      row.each.with_index do |el, y|
        result[x][y] = (el ? el.dup : nil)
      end
    end
    Board.new(result)
  end
end
