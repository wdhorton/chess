class ComputerPlayer
  attr_reader :color, :name, :display, :board

  def initialize(name, board, color)
    @board = board
    @display = Display.new(board)
    @name = name
    @color = color
  end

  def play_turn
    return take_piece unless take_piece.nil?
    own_pieces = board.pieces(color)
    valid_pieces = own_pieces.reject { |piece| piece.valid_moves.empty? }
    selected_piece = valid_pieces.sample
    end_pos = selected_piece.valid_moves.sample

    [selected_piece.pos, end_pos]


  end

  def take_piece
    own_pieces = board.pieces(color)
    valid_pieces = own_pieces.reject { |piece| piece.valid_moves.empty? }
    valid_pieces.each do |piece|
      piece.valid_moves.each do |pos|
        if board[pos]
          return [piece.pos, pos] if board[pos].color != color
        end
      end
    end

    nil
  end
end
