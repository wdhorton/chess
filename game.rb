require_relative 'board.rb'
require_relative 'human_player.rb'
require_relative 'display.rb'

class Game
  attr_accessor :board, :current_player
  attr_reader :players

  def initialize
    @board = Board.new
    @players = [HumanPlayer.new("Player 1", board, :white), HumanPlayer.new("Player 2", board, :black)]
    @current_player = players[0]
  end

  def play
    begin
      input = current_player.play_turn
      raise MoveError.new "That is not your piece!" if board[input[0]].color != current_player.color
      board.move(*input)
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
  end

  def over?
    board.checkmate?(:black) || board.checkmate?(:white)
  end

  def switch_players
    self.current_player = (current_player == players[0] ? players[1] : players[0])
  end

end

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.run
end
