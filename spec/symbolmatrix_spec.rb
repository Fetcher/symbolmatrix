require "symbolmatrix"

describe SymbolMatrix do
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

  describe "#store" do
    context "a key is stored using a symbol" do
      it "should be foundable with #[<symbol]" do
        a = SymbolMatrix.new
        a.store :a, 2
        a[:a].should == 2
      end
    end
  end
  
  it "should preserve the class of the argument" do
    class A < SymbolMatrix; end
    class B < SymbolMatrix; end
    
    a = A.new
    b = B.new

    a.a = b

    a.a.should be_instance_of B
  end

  describe "#update" do
    it "should take a hash as an argument" do
      t = SymbolMatrix.new
      t.update :a => 1
    end
    
    it "should add the hash to the matrix" do
      t = SymbolMatrix.new
      t.update :b => 2
      t['b'].should == 2
    end
  end

  describe "#merge!" do
    it "should take a hash as an argument and merge it into this matrix" do
      m = SymbolMatrix.new
      m.merge! :a => 1
      m[:a].should == 1
    end
  end

  describe "method_missing" do
    it "should return the same as the symbol representation of the method" do
      m = SymbolMatrix.new
      m.a = 3
      m[:a].should == 3
      m["a"].should == 3
      m.a.should == 3
    end
  end

  describe "#key?" do
    it "should return true when there is a value for that key" do
      m = SymbolMatrix.new
      m[:t] = 7
      m.key?(:t).should be_true
    end
  end

  describe ".new" do
    it "should accept a hash as an argument" do
      m = SymbolMatrix[:a, 1]
      m["a"].should == 1
      m[:a].should == 1
    end
  end  

  describe "#merge" do
    it "should return a merged instance" do
      m = SymbolMatrix.new
      m[:a] = 1
      m[:b] = 3
      n = m.merge :a => 2
      n[:a].should == 2
      n[:b].should == 3
    end
    
    it "should not alter this matrix" do
      m = SymbolMatrix.new
      m[:a] = 1
      m[:b] = 3
      n = m.merge :a => 2
      m[:a].should == 1
    end
  end

  describe "#to_hash" do
    it "should return an instance of Hash" do
      m = SymbolMatrix[:b, 1]
      m.to_hash.should be_instance_of Hash
    end
    
    it "should have the same keys" do
      m = SymbolMatrix[:a, 1]
      m.to_hash[:a].should == 1
    end
  end  
end
