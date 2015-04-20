require "plain_symbolmatrix_helper"

describe SymbolMatrix do
  describe "#validate_key" do
    context "an not convertible to Symbol key is passed" do
      it "raises a SymbolMatrix::InvalidKeyException" do
        m = SymbolMatrix.new
        o = Object.new
        expect { m.validate_key o
        }.to raise_error SymbolMatrix::InvalidKeyException, "The key '#{o}' does not respond to #to_sym, so is not a valid key for SymbolMatrix"
      end
    end
  end

  describe "#store" do
    context "a key is stored using a symbol" do
      it "is foundable with #[<symbol]" do
        a = SymbolMatrix.new
        a.store :a, 2
        expect(a[:a]).to eq 2
      end
    end

    context "the passed value is a Hash" do
      it "is converted into a SymbolTable" do
        a = SymbolMatrix.new
        a.store :b, { :c => 3 }
        expect(a[:b]).to be_a SymbolMatrix
      end
    end
  end

  shared_examples_for "any merging operation" do
    it "calls :store for every item in the passed Hash" do
      m = SymbolMatrix.new
      expect(m).to receive(:store).exactly(3).times
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
    it "calls #validate_key for each passed item" do
      m = SymbolMatrix.new
      expect(m).to receive(:validate_key).exactly(3).times.and_return(true)
      m.merge :a => 2, :b => 3, :c => 4
    end
  end

  describe "#[]" do
    context "the matrix is empty" do
      it "raises a SymbolMatrix::KeyNotDefinedException" do
        m = SymbolMatrix.new
        expect { m['t']
        }.to raise_error SymbolMatrix::KeyNotDefinedException, "The key :t is not defined"
      end
    end

    context "the matrix has a key defined using a symbol" do
      it "returns the same value when called with a string" do
        m = SymbolMatrix.new
        m[:s] = 3
        expect(m["s"]).to eq 3
      end
    end
  end

  describe "#to_hash" do
    it "shows a deprecation notice" do
      expect(Kernel).to receive(:warn).with "[DEPRECATION]: #to_hash is deprecated, please use #to.hash instead"
      SymbolMatrix.new.to_hash
    end
  end

  describe ".new" do
    context "a Hash is passed as argument" do
      it "accepts it" do
        m = SymbolMatrix.new :a => 1
        expect(m["a"]).to eq 1
        expect(m[:a]).to eq 1
      end
    end
  end

  describe "method_missing" do
    it "stores in a key named after the method without the '=' sign" do
      m = SymbolMatrix.new
      m.a = 4
      expect(m[:a]).to eq 4
    end

    it "returns the same as the symbol representation of the method" do
      m = SymbolMatrix.new
      m.a = 3
      expect(m[:a]).to eq 3
      expect(m["a"]).to eq 3
      expect(m.a).to eq 3
    end

    it "preserves the class of the argument" do
      class A < SymbolMatrix; end
      class B < SymbolMatrix; end

      a = A.new
      b = B.new

      a.a = b

      expect(a.a).to be_instance_of B
    end
  end

  describe "#recursive_merge" do
    it 'raises a relevant error when the two matrices collide' do
      sm = SymbolMatrix a: "hola"
      expect { sm.recursive_merge SymbolMatrix a: "hey"
      }.to raise_error SymbolMatrix::MergeError,
        "The value of the :a key is already defined. Run recursive merge with flag true if you want it to override"
    end

    it 'overrides on collide if the override flag is on' do
      sm = SymbolMatrix a: "hola"
      result = sm.recursive_merge SymbolMatrix(a: "hey"), true
      expect(result.a).to eq "hey"
    end

    it 'sends the override directive into the recursion' do
      sm = SymbolMatrix a: { b: "hola" }
      result = sm.recursive_merge SymbolMatrix( a: { b: "hey" } ), true
      expect(result.a.b).to eq "hey"
    end

    it 'merges two symbolmatrices' do
      sm = SymbolMatrix.new a: "hola"
      result = sm.recursive_merge SymbolMatrix.new b: "chau"
      expect(result.a).to eq "hola"
      expect(result.b).to eq "chau"
    end

    it 'merges two symbolmatrices (new values)' do
      sm = SymbolMatrix.new a: "hey"
      result = sm.recursive_merge SymbolMatrix.new b: "bye"
      expect(result.a).to eq "hey"
      expect(result.b).to eq "bye"
    end

    it 'merges two symbolmatrices (new keys)' do
      sm = SymbolMatrix.new y: "allo"
      result = sm.recursive_merge SymbolMatrix.new z: "ciao"
      expect(result.y).to eq "allo"
      expect(result.z).to eq "ciao"
    end

    it 'recursively merges this with that (simple)' do
      sm = SymbolMatrix.new another: { b: "aa" }
      result = sm.recursive_merge SymbolMatrix.new another: { c: "ee" }
      expect(result.another.b).to eq "aa"
      expect(result.another.c).to eq "ee"
    end

    it 'recursively merges this with that (simple)' do
      sm = SymbolMatrix.new distinct: { b: "rr" }
      result = sm.recursive_merge SymbolMatrix.new distinct: { c: "gg" }
      expect(result.distinct.b).to eq "rr"
      expect(result.distinct.c).to eq "gg"
    end

    it 'recursively merges this with that v2 (simple)' do
      sm = SymbolMatrix.new a: { z: "ee" }
      result = sm.recursive_merge SymbolMatrix.new a: { g: "oo" }
      expect(result.a.z).to eq "ee"
      expect(result.a.g).to eq "oo"
    end

    it 'recursively merges this with the argument hash' do
      sm = SymbolMatrix.new a: { b: { c: "hola" } }
      result = sm.recursive_merge a: { b: { d: "aaa" } }
      expect(result.a.b.c).to eq "hola"
      expect(result.a.b.d).to eq "aaa"
    end
  end

  describe '#recursive_merge!' do
    it 'raises a relevant error when the two matrices collide' do
      sm = SymbolMatrix a: "hola"
      expect { sm.recursive_merge! SymbolMatrix a: "hey"
      }.to raise_error SymbolMatrix::MergeError,
        "The value of the :a key is already defined. Run recursive merge with flag true if you want it to override"
    end

    it 'overrides on collide if the override flag is on' do
      sm = SymbolMatrix a: "hola"
      sm.recursive_merge! SymbolMatrix(a: "hey"), true
      expect(sm.a).to eq "hey"
    end

    it 'sends the override directive into the recursion' do
      sm = SymbolMatrix a: { b: "hola" }
      sm.recursive_merge! SymbolMatrix( a: { b: "hey" } ), true
      expect(sm.a.b).to eq "hey"
    end

    it 'merges a symbolmatrix into this' do
      sm = SymbolMatrix.new a: "hola"
      sm.recursive_merge! SymbolMatrix.new b: "chau"
      expect(sm.a).to eq "hola"
      expect(sm.b).to eq "chau"
    end

    it 'merges two symbolmatrices (new values)' do
      sm = SymbolMatrix.new a: "hey"
      sm.recursive_merge! SymbolMatrix.new b: "bye"
      expect(sm.a).to eq "hey"
      expect(sm.b).to eq "bye"
    end

    it 'merges two symbolmatrices (new keys)' do
      sm = SymbolMatrix.new y: "allo"
      sm.recursive_merge! SymbolMatrix.new z: "ciao"
      expect(sm.y).to eq "allo"
      expect(sm.z).to eq "ciao"
    end

    it 'recursively merges this with that (simple)' do
      sm = SymbolMatrix.new another: { b: "aa" }
      sm.recursive_merge! SymbolMatrix.new another: { c: "ee" }
      expect(sm.another.b).to eq "aa"
      expect(sm.another.c).to eq "ee"
    end

    it 'recursively merges this with that (simple)' do
      sm = SymbolMatrix.new distinct: { b: "rr" }
      sm.recursive_merge! SymbolMatrix.new distinct: { c: "gg" }
      expect(sm.distinct.b).to eq "rr"
      expect(sm.distinct.c).to eq "gg"
    end

    it 'recursively merges this with that v2 (simple)' do
      sm = SymbolMatrix.new a: { z: "ee" }
      sm.recursive_merge! SymbolMatrix.new a: { g: "oo" }
      expect(sm.a.z).to eq "ee"
      expect(sm.a.g).to eq "oo"
    end

    it 'recursively merges this with the argument hash' do
      sm = SymbolMatrix.new a: { b: { c: "hola" } }
      sm.recursive_merge! a: { b: { d: "aaa" } }
      expect(sm.a.b.c).to eq "hola"
      expect(sm.a.b.d).to eq "aaa"
    end
  end

  it 'is a method that calls SymbolMatrix.new with its arguments' do
    argument = double 'argument'
    expect(SymbolMatrix).to receive(:new).with argument
    SymbolMatrix argument
  end
end

describe SymbolMatrix::KeyNotDefinedException do
  it 'is a subclass of NoMethodError' do
    expect(
      SymbolMatrix::KeyNotDefinedException.superclass
    ).to eq NoMethodError
  end
end