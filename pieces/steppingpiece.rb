require_relative 'piece.rb'

class SteppingPiece < Piece
  def moves
    result = []
    move_dirs.each do |dx, dy|
      new_pos = [pos[0] + dx, pos[1] + dy]

      if on_board?(new_pos) && (empty?(new_pos) || opponent_there?(new_pos))
        result << new_pos
      end
    end

    result
  end
end
