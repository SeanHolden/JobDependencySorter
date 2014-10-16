require './spec/spec_helper'

describe Job do
  let(:error_message) { "Error: Input must be a comma separated string." }
  let(:no_argument_message) { "Note: An argument must be entered." }


  describe "initializer" do
    context "non-string argument is entered" do
      let(:error_message) { "Error: Input must be a comma separated string." }

      it "integer argument returns correct error" do
        expect{ Job.new(123) }
        .to raise_error(ArgumentError,error_message )
      end

      it "array argument returns correct error" do
        expect{ Job.new(['test','array']) }
        .to raise_error(ArgumentError, error_message)
      end

      it "hash argument returns correct error" do
        expect{ Job.new({:test=>'hash'}) }
        .to raise_error(ArgumentError, error_message)
      end
    end
  end

  describe "sort method" do
    context "no argument is entered" do
      let(:error_message) { "Error: An argument must be entered." }

      it "returns appropriate message if nothing is entered as an argument" do
        expect{ Job.new() }
        .to raise_error(ArgumentError, error_message)
      end
    end
  end

end