require_relative 'board.rb'
require_relative 'human_player.rb'
require_relative 'display.rb'
require_relative 'computer_player.rb'

class Game
  attr_accessor :board, :current_player
  attr_reader :players

  def initialize(players_count)
    @board = Board.new
    if players_count == 1
      @players = [HumanPlayer.new("Player 1", board, :white), ComputerPlayer.new("Computer", board, :black)]
    elsif players_count == 2
      @players = [HumanPlayer.new("Player 1", board, :white), HumanPlayer.new("Player 2", board, :black)]
    end
    @current_player = players[0]
  end

  def play
    begin
      input = current_player.play_turn
      current_piece = board[input[0]]
      raise MoveError.new "No piece in that square!" if current_piece.nil?
      raise MoveError.new "That is not your piece!" if current_piece.color != current_player.color
      board.move(*input)
      current_piece.promotion if current_piece.class == Pawn
      switch_players
    rescue MoveError => e
      puts e.message
      sleep(3)
      retry
    end
  end

  def run
    until over?
      play
    end
    game_over
  end

  def over?
    board.checkmate?(:black) || board.checkmate?(:white) || board.draw?(current_player.color)
  end

  def switch_players
    self.current_player = (current_player == players[0] ? players[1] : players[0])
  end

  def game_over
    current_player.display.render
    if board.checkmate?(:black)
      puts "Checkmate! White wins!"
    elsif board.checkmate?(:white)
      puts "Checkmate! Black wins!"
    else
      puts "It's a draw!"
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  puts "How many players? (1 / 2) "
  players_count = gets.chomp.to_i

  g = Game.new(players_count)
  g.run
end
