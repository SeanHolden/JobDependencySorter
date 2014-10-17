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

    context "no argument is entered" do
      let(:error_message) { "Error: An argument must be entered." }

      it "returns appropriate message if nothing is entered as an argument" do
        expect{ Job.new() }
        .to raise_error(ArgumentError, error_message)
      end
    end
  end

  describe "is_valid? method" do
    # Using send to test a private method as I feel it is necessary to test this.
    let(:dependency_rules) { [['b','e'],['c','f'],['d','a'],['e','c']] }
    let(:job) { Job.new('a,b,c') } #<- the argument doesn't matter for this method

    it "returns false value if array does not meet all required dependencies" do
      job_order = %w(a b c d e f)
      expect( job.send(:is_valid?, job_order, dependency_rules) ).to eq false
    end

    it "returns true if array meets all required dependencies" do
      job_order = %w(a f c e b d)
      expect( job.send(:is_valid?, job_order, dependency_rules) ).to eq true
    end
  end

  describe "sort method" do
    it "should sort jobs correctly (test 1)" do
      pending
      fail
      job = Job.new("a =>,b => c,c => f,d => a,e => b,f =>")
      expect( job.sort ).to eq %w( a f c b d e )
    end

    it "should sort jobs correctly (test 2)" do
      pending
      fail
      job = Job.new("a =>,b => c, c=>")
      expect( job.sort ).to eq %w( a c b )
    end

    it "should sort jobs correctly (test 3)" do
      pending
      fail
      job = Job.new("a=>c,b=>,c=>g,d=>e,e=>,f=>a,g=>")
      expect( job.sort ).to eq %w(g c a b e d f)
    end

    it "should sort jobs correctly (test 4)" do
      pending
      fail
      job = Job.new("a=>,b=>e,c=>f,d=>a,e=>c,f=>")
      expect( job.sort ).to eq %w( a d f c e b )
    end
  end

  context "errors" do
    it "returns error when a job is trying to depend on itself" do
      pending
      fail
    end

    it "returns error when a job is trying to have circular dependencies" do
      pending
      fail
    end
  end

end