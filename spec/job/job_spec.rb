require './spec/spec_helper'

describe Job do
  let(:error_message) { "Error: Input must be a comma separated string." }
  let(:no_argument_message) { "Note: An argument must be entered." }


  describe "initializer" do

    context "errors" do
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

      it "returns appropriate error if no '=>' symbol is found" do
        expect{ Job.new('a,b,c') }
        .to raise_error(ArgumentError, "Error: input must contain '=>' symbols to indicate dependencies.")
      end

      it "returns appropriate error if nothing is entered as an argument" do
        expect{ Job.new() }
        .to raise_error(ArgumentError, "Error: An argument must be entered." )
      end

      it "returns error when a job is trying to depend on itself" do
        expect{ Job.new("a=>b,b=>b,c=>") }
        .to raise_error(SelfDependency, "Error: Jobs can’t depend on themselves.")
      end

      it "returns error when a job is trying to have circular dependencies" do
        expect{ Job.new("a=>,b=>c,c=>f,d=>a,e=>,f=>b") }
        .to raise_error(CircularDependency, "Error: Jobs can’t have circular dependencies.")
      end

      it "returns error if a job appears on the right that is not anywhere else in the job list." do
        expect{ Job.new("a=>c,b=>,c=>z,d=>e,e=>,f=>a,g=>") }
        .to raise_error(UndeclaredJob, "Error: All jobs must be declared on the left hand side.")
      end
    end

  end

  describe "sort method" do
    it "sorts jobs into correct order (test 1)" do
      job = Job.new("a =>,b => c,c => f,d => a,e => b,f =>")
      expect( job.sort ).to eq %w( a f c b d e )
    end

    it "sorts jobs into correct order (test 2)" do
      job = Job.new("a =>,b => c, c=>")
      expect( job.sort ).to eq %w( a c b )
    end

    it "sorts jobs into correct order (test 3)" do
      job = Job.new("a=>c,b=>,c=>g,d=>e,e=>,f=>a,g=>")
      expect( job.sort ).to eq %w(g c a b e d f)
    end

    it "sorts jobs into correct order (test 4)" do
      job = Job.new("a=>,b=>e,c=>f,d=>a,e=>c,f=>")
      expect( job.sort ).to eq %w( a f c e b d )
    end
  end

end