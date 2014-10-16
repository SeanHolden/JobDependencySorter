require './spec/spec_helper'

describe Job do
  let(:job) { Job.new }

  context "sort method" do

    it "returns appropriate error message if non-string argument is entered" do
      expect( job.sort(123) ).to eq "Error: Input must be a comma separated string."
    end

  end

end