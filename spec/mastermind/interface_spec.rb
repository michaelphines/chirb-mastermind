require File.join(File.dirname(__FILE__), "/../spec_helper")

module Mastermind
  describe Interface do
    before(:each) do
      @output, @input = StringIO.new, StringIO.new
      @interface = Interface.new(@output, @input)
    end
    
    describe "#initalize" do
      it "should set the game to a new game" do
        @input.stub(:readline).and_return("")
        game = mock("game")
        Game.should_receive(:new).and_return(game)
        Interface.new
      end
    end

    describe "#start" do
      before(:each) do
        @interface.stub(:play_again)
        @interface.game.stub(:guess)
        @interface.game.stub(:over?).and_return(true)
      end

      it "should start the game" do
        @input.stub(:readline).and_return("")
        @interface.game.should_receive(:start)
        @interface.start
      end
      
      it "should keep guessing until the game is over" do
        @interface.game.should_receive(:over?).and_return(true)
        @interface.start
      end
      
      it "should call for an option to play again" do
        @interface.should_receive(:play_again)
        @interface.start
      end
    end
    
    describe "#play_again" do
      before(:each) do
        @input.stub(:readline).and_return("")
      end
      
      it "should ask to play again" do
        @output.should_receive(:puts).with("Would you like to play again?")
        @input.stub(:readline).and_return("no")
        @interface.stub(:exit)
        @interface.play_again
      end
      
      it "should play again if the response is yes" do
        @input.should_receive(:readline).and_return("yes")
        @interface.should_receive(:reset_game)
        @interface.should_not_receive(:exit)
        @interface.play_again
      end
      
      it "should play again if the response is yEs" do
        @input.should_receive(:readline).and_return("yEs")
        @interface.should_receive(:reset_game)
        @interface.should_not_receive(:exit)
        @interface.play_again
      end
      
      it "should play again if the response is y" do
        @input.should_receive(:readline).and_return("y")
        @interface.should_receive(:reset_game)
        @interface.should_not_receive(:exit)
        @interface.play_again
      end
      
      it "should not play again if the response is no" do
        @input.should_receive(:readline).and_return("no")
        @interface.should_not_receive(:reset_game)
        @interface.should_receive(:exit)
        @interface.play_again
      end
      
      it "should not play again if the response is n" do
        @input.should_receive(:readline).and_return("n")
        @interface.should_not_receive(:reset_game)
        @interface.should_receive(:exit)
        @interface.play_again
      end

    end
    
    describe "#guess" do
      before(:each) do
        @interface.game.stub(:guess)
      end
      
      it "should read from input" do
        @input.should_receive(:readline).and_return("")
        @interface.guess
      end
      
      it "should guess from the input" do
        @input.stub(:readline).and_return("guess\n")
        @interface.game.should_receive(:guess).with(%w[g u e s s])
        @interface.guess
      end
      
      it "should exit I type exit" do
        @input.stub(:readline).and_return("exit\n")
        @interface.should_receive(:exit)
        @interface.guess
      end
    end
    
    describe "#exit" do
      it "should exit and say goodbye" do
        @output.should_receive(:puts).with("Thanks for playing! Goodbye.")
        Kernel.should_receive(:exit)
        @interface.exit
      end
    end
    
    describe "#game" do
      it "should return the game" do
        game = mock("game")
        @interface.instance_variable_set("@game", game)
        @interface.game.should == game
      end
    end
  end
end