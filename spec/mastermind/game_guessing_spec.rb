require File.join(File.dirname(__FILE__), "/../spec_helper")

module Mastermind
  describe Game do
    context "guessing" do
      before(:each) do
        @messenger = mock("messenger").as_null_object
        @game = Game.new(@messenger)
        @correct_guess = %w[r g y b]
        @incorrect_guess = %w[w w w w]
        @game.start(@correct_guess)
      end

      context "errors" do 
        describe "#guess" do
          it "should print an error with the wrong colors" do
            @messenger.should_receive(:puts).with("The possible colors are bcgryw.")
            @game.guess(%w[a a a a])          
          end
        
          it "should not print an error with correct colors" do
            @messenger.should_not_receive(:puts).with("The possible colors are bcgryw.")
            @game.guess(@incorrect_guess)          
          end
        
          it "should print an error if the guessed code is too short" do
            @game.should_not_receive(:mark)
            @messenger.should_receive(:puts).with("The code should be 4 colors long.")
            @game.guess(%w[w w w])
          end
        
          it "should print an error if the guessed code is too long" do
            @game.should_not_receive(:mark)
            @messenger.should_receive(:puts).with("The code should be 4 colors long.")
            @game.guess(%w[w w w w w])
          end
        
          it "should not print an error if the guessed code is the right length" do
            @messenger.should_not_receive(:puts).with("The code should be 4 colors long.")
            @game.guess(%w[w w w w])
          end
        end
      end

      describe "#guess" do
        it "should call #mark with the guess and print the result" do
          @game.should_receive(:mark).and_return("mark")
          @messenger.should_receive(:puts).with("mark")
          @game.guess(@incorrect_guess)
        end
        
        it "should increment the number of guesses" do
          @game.instance_variable_set("@guesses", 11)
          @game.guess(@incorrect_guess)
          @game.instance_variable_get("@guesses").should == 12          
        end
      end
      
      describe "#mark" do
        it "should return bb for two correct places only" do
          @game.mark(%w[r w y w]).should == "bb"
        end

        it "should return ww for two incorrect places only" do
          @game.mark(%w[w y g c]).should == "ww"
        end
        
        it "should return a sorted response for a mixed result" do
          @game.mark(%w[r y g r]).should == "bww"          
        end
      end
      
      context "an incorrect guess" do
        describe "#guess" do
          it "should ask the user to enter another guess" do
            @messenger.should_receive(:puts).with("Enter guess (bcgryw) or 'exit':")
            @game.guess(@incorrect_guess)
          end
        end
      end
      
      context "a correct guess" do
        describe "#over?" do
          it "should return true" do
            @game.guess(@correct_guess)
            @game.should be_over
          end
        end

        describe "#mark" do
          it "should return 'bbbb'" do
            @game.mark(@correct_guess).should == 'bbbb'
          end
        end

        describe "#guess" do
          context "in less than 3 guesses" do
            it "should congratulate the user with the number of guesses" do
              @game.should_receive(:guesses).and_return("the number of guesses")
              @messenger.should_receive(:puts).with("Congratulations! You broke the code in the number of guesses.")
              @game.guess(@correct_guess)
            end
          end
          
          context "in 3 or more guesses" do
            it "should just tell the user the number of guesses" do
              @game.instance_variable_set("@guesses", 3)
              @game.should_receive(:guesses).and_return("the number of guesses")
              @messenger.should_receive(:puts).with("You broke the code in the number of guesses.")
              @game.guess(@correct_guess)
            end
            
            it "should just tell the user the number of guesses" do
              @game.instance_variable_set("@guesses", 5)
              @game.should_receive(:guesses).and_return("the number of guesses")
              @messenger.should_receive(:puts).with("You broke the code in the number of guesses.")
              @game.guess(@correct_guess)
            end
          end
        end
      
        describe "#guesses" do
          context "in one guess" do
            it "should return '1 guess' on 1 guess" do
              @game.instance_variable_set("@guesses", 1)
              @game.guesses.should == "1 guess"
            end
          end
        
          context "in more than one guess" do
            it "should return '2 guesses' on 2 guesses" do
              @game.instance_variable_set("@guesses", 2)
              @game.guesses.should == "2 guesses"
            end
          
            it "should return '5 guesses' on 5 guesses" do
              @game.instance_variable_set("@guesses", 5)
              @game.guesses.should == "5 guesses"
            end
          end
        end 
        
      end 
    end
    
  end
end
