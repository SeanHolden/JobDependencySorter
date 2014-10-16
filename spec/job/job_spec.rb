require './spec/spec_helper'

describe Job do
  let(:job) { Job.new }
  let(:error_message) { "Error: Input must be a comma separated string." }
  let(:no_argument_message) { "Note: An argument must be entered." }

  context "sort method" do

    it "returns appropriate error message if non-string argument is entered" do
      # Testing for integer, array and hash input
      expect( job.sort(123) ).to eq error_message
      expect( job.sort(['test','array']) ).to eq error_message
      expect( job.sort({:test=>'hash'}) ).to eq error_message
    end

    it "returns appropriate message if nothing is entered as an argument" do
      expect( job.sort ).to eq no_argument_message
    end

  end

end