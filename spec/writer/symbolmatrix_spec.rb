require 'complete_features_helper'

describe Writer::SymbolMatrix do 
  describe '#initialize' do 
    it 'should set the argument as the source' do 
      source = stub 'source'
      writer = Writer::SymbolMatrix.new source
      writer.source.should == source
    end
  end

  describe '#hash' do 
    it "should return an instance of Hash" do
      m = SymbolMatrix[:b, 1]
      writer = Writer::SymbolMatrix.new m
      writer.hash.should be_instance_of Hash
    end
    
    it "should have the same keys" do
      m = SymbolMatrix[:a, 1]
      writer = Writer::SymbolMatrix.new m
      writer.hash[:a].should == 1
    end

    it "should have the same keys (more keys)" do
      m = SymbolMatrix[:a, 2]
      writer = Writer::SymbolMatrix.new m
      writer.hash[:a].should == 2
    end
    
    context "there is some SymbolMatrix within this SymbolMatrix" do
      it "should recursively call #to.hash in it" do
        in_writer = stub 'inside writer'

        inside = SymbolMatrix.new
        inside.should_receive(:to).and_return in_writer
        in_writer.should_receive(:hash)
        
        m = SymbolMatrix[:a, inside]
        writer = Writer::SymbolMatrix.new m
        writer.hash
      end
    end
  end

  shared_examples_for 'any serialization' do 
    it 'should serialize "try: this" into "try:this"' do 
      s = SymbolMatrix try: "this"
      writer = Writer::SymbolMatrix.new s
      writer.send(@method).should == "try:this"
    end

    it 'should serialize "try: that" into "try:that"' do 
      s = SymbolMatrix try: "that"
      Writer::SymbolMatrix
        .new(s).send(@method).should == "try:that"
    end

    it 'should serialize "attempt: this" into "attempt:this"' do
      Writer::SymbolMatrix
        .new(SymbolMatrix(attempt: "this"))
        .send(@method).should == "attempt:this"
    end

    it 'should serialize "attempt: that" into "attempt:that"' do
      Writer::SymbolMatrix
        .new(SymbolMatrix(attempt: "that"))
        .send(@method).should == "attempt:that"
    end

    it 'should serialize a more complex hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(a: "b", c: "d"))
        .send(@method).should == "a:b c:d"
    end

    it 'should serialize a more complex hash with different values' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(g: "e", r: "t"))
        .send(@method).should == "g:e r:t"
    end

    it 'should serialize a multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(g: {e: "s"}))
        .send(@method).should == "g.e:s"
    end

    it 'should serialize a different multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(r: {e: "s"}))
        .send(@method).should == "r.e:s"
    end

    it 'should serialize a yet different multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(r: {a: "s"}))
        .send(@method).should == "r.a:s"
    end

    it 'should serialize a more complex multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(r: {a: "s", f: "o"}))
        .send(@method).should == "r.a:s r.f:o"
    end

    it 'should serialize a different more complex multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(r: {ar: "s", fe: "o"}))
        .send(@method).should == "r.ar:s r.fe:o"
    end

    it 'should serialize a yet different more complex multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(r: {ar: "s", fe: "o", wh: "at"}))
        .send(@method).should == "r.ar:s r.fe:o r.wh:at"
    end

    it 'should serialize a more complex multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(r: {a: { f: "o", s: "h", y: "u"}}))
        .send(@method).should == "r.a.f:o r.a.s:h r.a.y:u"
    end

    it 'should transform the multidimentional hash into a simple dot and colons serialization' do 
      multidimentional = SymbolMatrix.new hola: {
          the: "start",
          asdfdf: 8989,
          of: {
            some: "multidimentional"
          }
        },
        stuff: "oops"
      
      writer = Writer::SymbolMatrix.new multidimentional
      writer.send(@method).should == "hola.the:start hola.asdfdf:8989 hola.of.some:multidimentional stuff:oops"
    end
  end

  describe '#serialization' do 
    before { @method = :serialization }
    it_behaves_like 'any serialization'
  end

  describe '#smas' do 
    before { @method = :smas }
    it_behaves_like 'any serialization'
  end
end

describe SymbolMatrix do
  it 'should include the Discoverer for Writer' do 
    SymbolMatrix.ancestors.should include Discoverer::Writer
  end
end
