module Mastermind
  COLORS = %w[b c g r y w]
  
  class Game    
    def initialize(messenger)
      @messenger = messenger
      @guesses = 0
      @over = false
    end

    def mark(guess)
      # Find the correct placement first
      correct = (0..3).select {|n| guess[n] == @secret_code[n]}.length

      # Count each color in each code
      secret_hash, guess_hash = Hash.new(0), Hash.new(0)
      @secret_code.each { |g| secret_hash[g] += 1 }
      guess.each { |g| guess_hash[g] += 1 }
      
      # The minimum of the number of colors in each hash is the number
      # of correct color guesses, regardless of position
      duplicates = guess_hash.collect{ |k,v| [secret_hash[k], v].min }
      misplaced = duplicates.inject(0) { |v,sum| sum + v } - correct
      # I wish everyone had ruby 1.9.1 and Array#sum
      
      # Print out the code
      "b"*correct + "w"*misplaced
    end
    
    # Better to use the ActiveSupport inflector when available, 
    # but we only have to do this with one word.
    def guesses
      plural = (@guesses > 1) ? "es" : ""
      "#{@guesses} guess#{plural}"
    end
    
    def guess(guess)
      unless guess.length == 4
        @messenger.puts("The code should be 4 colors long.") 
        return
      end
      
      unless (guess - COLORS).empty?
        @messenger.puts("The possible colors are bcgryw.") 
        return
      end        
      
      @guesses += 1
      result = mark(guess)
      @messenger.puts result
      if (result == 'bbbb')
        # Only congratulate the user if they were lucky
        congratulations = (@guesses < 3) ? "Congratulations! " : ""
        @messenger.puts "#{congratulations}You broke the code in #{guesses}."
        @over = true
      else
        request_guess()
      end
    end
        
    def start(secret_code = nil)
      @secret_code = secret_code || Game.random_code
      @messenger.puts "Welcome to Mastermind!"
      request_guess()
    end
    
    def secret_code
      @secret_code
    end
    
    def request_guess
      @messenger.puts "Enter guess (#{COLORS.join}) or 'exit':"
    end
        
    def over?
      @over
    end

    class << self
      def random_code
        (1..4).collect {|n| COLORS[rand(COLORS.length)]}
      end
    end
    
  end
end