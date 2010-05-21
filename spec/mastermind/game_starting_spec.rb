require File.join(File.dirname(__FILE__), "/../spec_helper")

module Mastermind
  describe Game do
    context "starting up" do
      before(:each) do
        @messenger = mock("messenger").as_null_object
        @game = Game.new(@messenger)
      end
      
      describe "#start" do
        it "should generate a random code if one is not given" do
          Game.should_receive(:random_code).and_return("random code")
          @game.start
          @game.instance_variable_get("@secret_code").should == "random code"
        end
        
        it "should use the given code" do
          code = %w[w w w w]
          @game.start(code)
          @game.instance_variable_get("@secret_code").should == code
        end
        
        it "should send a welcome message" do
          @messenger.should_receive(:puts).with("Welcome to Mastermind!")
          @game.start(%w[w w w w])
        end

        it "should prompt for the first guess" do
          @messenger.should_receive(:puts).with("Enter guess (bcgryw) or 'exit':")
          @game.start(%w[w w w w])
        end
      end
      
      describe "#over" do
        it "should be false" do
          @game.should_not be_over
        end
      end
    end
  end
end
