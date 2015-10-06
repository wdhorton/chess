require_relative 'piece.rb'

class Pawn < Piece
  def initialize(board, pos, color)
    super(board, pos, color)
    @start_pos = pos
  end

  def direction
    @start_pos[0] == 1 ? :down : :up
  end

  def moves
    result = []
    dy = 1
    x, y = pos
    dy *= -1 if direction == :up
    result << [x + dy, y] if empty?([x + dy, y])
    result << [x + (2 * dy), y] if pos == @start_pos && empty?([x + 2 * dy, y])
    new_pos = [x + dy, y - 1]
    result << new_pos  if board[new_pos] && opponent_there?(new_pos)
    new_pos = [x + dy, y + 1]
    result << new_pos  if board[new_pos] && opponent_there?(new_pos)
    result
  end

  def to_s
    super " ♟ "
  end

  def promotion(player)
    if (direction == :up && pos[0] == 0) || (direction == :down && pos[0] == 7)
      prompt_promotion(player)
    end
  end

  def prompt_promotion(player)
    if player.class == ComputerPlayer
      board[pos] = Queen.new(board, pos, color)
    else
      b = Board.new(false)

      Rook.new(b, [7, 0], color)
      Knight.new(b, [7, 1], color)
      Bishop.new(b, [7, 2], color)
      Queen.new(b, [7, 3], color)


      d = Display.new(b)
      input = nil
      until input
        d.render
        puts "Select your new piece"
        input = d.get_input
      end
      board[pos] = b[input].class.new(board,pos,color)
    end
  end
end
