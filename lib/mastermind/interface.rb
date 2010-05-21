module Mastermind
  class Interface
    def initialize(output = STDOUT, input = STDIN)
      @output = output
      @input = input
      @game = Game.new(@output)
    end
    
    def start
      @game.start
      guess() until (@game.over?)
      play_again()
    end
    
    def guess
      input = @input.readline.chomp
      exit() if input == "exit"
      code = input.split(/\W*/)
      @game.guess(code) 
    end
    
    def exit
      @output.puts("Thanks for playing! Goodbye.")
      Kernel.exit
    end
    
    def play_again
      @output.puts("Would you like to play again?")
      answer = @input.readline.chomp.downcase
      if answer == "yes" || answer == "y"
        reset_game()
      elsif answer == "no" || answer == "n"
        exit()
      else
        play_again()
      end
    end
    
    def reset_game
      @game = Game.new(@output)
      start()
    end
    
    def game
      @game
    end
  end
end