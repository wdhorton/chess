require_relative 'piece.rb'

class SlidingPiece < Piece
  def moves
    result = []
    move_dirs.each do |dx, dy|
      a = pos
      a = [a[0] + dx, a[1] + dy]
      while on_board?(a) && board[a].nil?
        result << a
        a = [a[0] + dx, a[1] + dy]
      end

      result << a if on_board?(a) && board[a].color != color
    end

  result
  end
end
