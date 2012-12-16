require "plain_symbolmatrix_helper"

describe SymbolMatrix do
  describe "#validate_key" do
    context "an not convertible to Symbol key is passed" do
      it "should raise a SymbolMatrix::InvalidKeyException" do
        m = SymbolMatrix.new
        o = Object.new
        expect { m.validate_key o
        }.to raise_error SymbolMatrix::InvalidKeyException, "The key '#{o}' does not respond to #to_sym, so is not a valid key for SymbolMatrix"
      end
    end
  end
  
  describe "#store" do
    context "a key is stored using a symbol" do
      it "should be foundable with #[<symbol]" do
        a = SymbolMatrix.new
        a.store :a, 2
        a[:a].should == 2
      end
    end
    
    context "the passed value is a Hash" do
      it "should be converted into a SymbolTable" do
        a = SymbolMatrix.new
        a.store :b, { :c => 3 }
        a[:b].should be_a SymbolMatrix
      end
    end
  end
  
  shared_examples_for "any merging operation" do
    it "should call :store for every item in the passed Hash" do
      m = SymbolMatrix.new
      m.should_receive(:store).exactly(3).times
      m.send @method, { :a => 1, :b => 3, :c => 4 }
    end
  end

  describe "#merge!" do
    before { @method = :merge! }
    it_behaves_like "any merging operation"
  end  
  
  describe "#update" do
    before { @method = :update }
    it_behaves_like "any merging operation"
  end

  describe "#merge" do
    it "should call #validate_key for each passed item" do
      m = SymbolMatrix.new
      m.should_receive(:validate_key).exactly(3).times.and_return(true)
      m.merge :a => 2, :b => 3, :c => 4
    end
  end

  describe "#[]" do
    context "the matrix is empty" do
      it "should raise a SymbolMatrix::KeyNotDefinedException" do
        m = SymbolMatrix.new
        expect { m['t']
        }.to raise_error SymbolMatrix::KeyNotDefinedException, "The key :t is not defined"
      end
    end
    
    context "the matrix has a key defined using a symbol" do
      it "should return the same value when called with a string" do
        m = SymbolMatrix.new
        m[:s] = 3
        m["s"].should == 3
      end
    end
  end

  describe "#to_hash" do
    it "should show a deprecation notice" do
      Kernel.should_receive(:warn).with "[DEPRECATION]: #to_hash is deprecated, please use #to.hash instead" 
      SymbolMatrix.new.to_hash
    end
  end

  describe ".new" do
    context "a Hash is passed as argument" do
      it "should accept it" do
        m = SymbolMatrix.new :a => 1
        m["a"].should == 1
        m[:a].should == 1
      end
    end
  end    

  describe "method_missing" do
    it "should store in a key named after the method without the '=' sign" do
      m = SymbolMatrix.new
      m.a = 4
      m[:a].should == 4
    end
    
    it "should return the same as the symbol representation of the method" do
      m = SymbolMatrix.new
      m.a = 3
      m[:a].should == 3
      m["a"].should == 3
      m.a.should == 3
    end

    it "should preserve the class of the argument" do
      class A < SymbolMatrix; end
      class B < SymbolMatrix; end
      
      a = A.new
      b = B.new

      a.a = b

      a.a.should be_instance_of B
    end
  end

  describe "#recursive_merge" do 
    it 'should merge two symbolmatrices' do 
      sm = SymbolMatrix.new a: "hola"
      result = sm.recursive_merge SymbolMatrix.new b: "chau"
      result.a.should == "hola"
      result.b.should == "chau"
    end

    it 'should merge two symbolmatrices (new values)' do 
      sm = SymbolMatrix.new a: "hey"
      result = sm.recursive_merge SymbolMatrix.new b: "bye"
      result.a.should == "hey"
      result.b.should == "bye"
    end

    it 'should merge two symbolmatrices (new keys)' do 
      sm = SymbolMatrix.new y: "allo"
      result = sm.recursive_merge SymbolMatrix.new z: "ciao"
      result.y.should == "allo"
      result.z.should == "ciao"
    end

    it 'should recursively merge this with that (simple)' do 
      sm = SymbolMatrix.new another: { b: "aa" }
      result = sm.recursive_merge SymbolMatrix.new another: { c: "ee" }
      result.another.b.should == "aa"
      result.another.c.should == "ee"
    end

    it 'should recursively merge this with that (simple)' do 
      sm = SymbolMatrix.new distinct: { b: "rr" }
      result = sm.recursive_merge SymbolMatrix.new distinct: { c: "gg" }
      result.distinct.b.should == "rr"
      result.distinct.c.should == "gg"
    end

    it 'should recursively merge this with that v2 (simple)' do
      sm = SymbolMatrix.new a: { z: "ee" }
      result = sm.recursive_merge SymbolMatrix.new a: { g: "oo" }
      result.a.z.should == "ee"
      result.a.g.should == "oo"
    end

    it 'should recursively merge this with the argument hash' do 
      sm = SymbolMatrix.new a: { b: { c: "hola" } }
      result = sm.recursive_merge a: { b: { d: "aaa" } }
      result.a.b.c.should == "hola"
      result.a.b.d.should == "aaa"
    end
  end

  it 'should be a method that calls SymbolMatrix.new with its arguments' do 
    argument = stub 'argument'
    SymbolMatrix.should_receive(:new).with argument
    SymbolMatrix argument
  end
end
