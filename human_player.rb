class HumanPlayer
  attr_reader :color, :name

  def initialize(name, board, color)
    @display = Display.new(board)
    @name = name
    @color = color
  end

  def play_turn
    result = []
    until result.length == 2
      @display.render
      puts "It is #{name}'s turn"
      input = @display.get_input
      result << input if input
    end

    result
  end
end
