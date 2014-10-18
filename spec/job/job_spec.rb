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

      it "returns empty array if nothing is entered as an argument" do
        expect( Job.new().sort ).to eq []
        expect( Job.new('').sort ).to eq []
      end

      it "returns error when a job is trying to depend on itself" do
        expect{ Job.new("a=>b,b=>b,c=>") }
        .to raise_error(SelfDependency, "Error: Jobs can’t depend on themselves.")
      end

      it "returns error when a job is trying to have circular dependencies" do
        expect{ Job.new("a=>,b=>c,c=>f,d=>a,e=>,f=>b") }
        .to raise_error(CircularDependency, "Error: Jobs can’t have circular dependencies. (c=>f;f=>b;b=>c;)")
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

    it "sorts jobs into correct order (test 4)" do
      job = Job.new("a=>b,b=>d,c=>g,d=>,e=>f,f=>,g=>a")
      expect( job.sort ).to eq %w( d b a g c f e )
    end

    it "sorts jobs into correct order (test 5)" do
      job = Job.new("a=>j,b=>i,c=>h,d=>g,e=>f,f=>g,g=>a,h=>b,i=>e,j=>")
      expect( job.sort ).to eq %w( j a g f e i b h c d )
    end

    it "sorts jobs into correct order (test 6 - the big one)" do
      job = Job.new("a=>b,b=>d,c=>g,d=>,e=>f,f=>,g=>a,h=>i,i=>a,j=>c,k=>b,l=>f,m=>o,n=>,o=>,p=>e")
      expect( job.sort ).to eq %w( d b a g c f e i h j k l o m n p )
    end

    it "sorts jobs into correct order (test 7 - the whole alphabet)" do
      job = Job.new("a=>x,b=>o,c=>h,d=>x,e=>z,f=>d,g=>h,h=>k,i=>v,j=>g,k=>m,l=>a,m=>,n=>x,o=>q,p=>w,q=>g,r=>o,s=>u,t=>n,u=>c,v=>w,w=>,x=>,y=>d,z=>x")
      expect( job.sort ).to eq %w( x a m k h g q o b c d z e f w v i j l n p r u s t y )
    end

    it "can read in job dependencies from a file and output correct results" do
      f = File.read('spec/test.txt')
      job = Job.new(f)
      expect( job.sort ).to eq %w( j a g f e i b h c d )
    end
    
  end

end