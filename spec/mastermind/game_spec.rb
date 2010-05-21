require File.join(File.dirname(__FILE__), "/../spec_helper")

module Mastermind
  describe Game do
    
    describe ".random_code" do
      it "should return 4 random colors" do
        Game.should_receive(:rand).exactly(4).times.with(Mastermind::COLORS.length).and_return(1)
        color = Mastermind::COLORS[1]
        Game.random_code.should == (1..4).collect {|n| color}
      end
    end
    
    describe "#secret_code" do
      it "should return the secret code" do
        game = Game.new(StringIO.new)
        game.instance_variable_set("@secret_code", "secret code")
        game.secret_code.should == "secret code"
      end
    end
    
  end
end
