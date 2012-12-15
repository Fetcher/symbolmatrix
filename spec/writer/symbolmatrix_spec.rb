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
    it 'should do the same as current #to_hash'
  end

  describe '#serialization' do 
    it 'should serialize "try: this" into "try:this"' do 
      s = SymbolMatrix try: "this"
      writer = Writer::SymbolMatrix.new s
      writer.serialization.should == "try:this"
    end

    it 'should serialize "try: that" into "try:that"' do 
      s = SymbolMatrix try: "that"
      Writer::SymbolMatrix
        .new(s).serialization.should == "try:that"
    end

    it 'should serialize "attempt: this" into "attempt:this"' do
      Writer::SymbolMatrix
        .new(SymbolMatrix(attempt: "this"))
        .serialization.should == "attempt:this"
    end

    it 'should serialize "attempt: that" into "attempt:that"' do
      Writer::SymbolMatrix
        .new(SymbolMatrix(attempt: "that"))
        .serialization.should == "attempt:that"
    end

    it 'should serialize a more complex hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(a: "b", c: "d"))
        .serialization.should == "a:b c:d"
    end

    it 'should serialize a more complex hash with different values' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(g: "e", r: "t"))
        .serialization.should == "g:e r:t"
    end

    it 'should serialize a multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(g: {e: "s"}))
        .serialization.should == "g.e:s"
    end

    it 'should serialize a different multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(r: {e: "s"}))
        .serialization.should == "r.e:s"
    end

    it 'should serialize a yet different multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(r: {a: "s"}))
        .serialization.should == "r.a:s"
    end

    it 'should serialize a more complex multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(r: {a: "s", f: "o"}))
        .serialization.should == "r.a:s r.f:o"
    end

    it 'should serialize a different more complex multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(r: {ar: "s", fe: "o"}))
        .serialization.should == "r.ar:s r.fe:o"
    end

    it 'should serialize a yet different more complex multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(r: {ar: "s", fe: "o", wh: "at"}))
        .serialization.should == "r.ar:s r.fe:o r.wh:at"
    end

    it 'should serialize a more complex multidimentional hash' do 
      Writer::SymbolMatrix
        .new(SymbolMatrix(r: {a: { f: "o", s: "h", y: "u"}}))
        .serialization.should == "r.a.f:o r.a.s:h r.a.y:u"
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
      writer.serialization.should == "hola.the:start hola.asdfdf:8989 hola.of.some:multidimentional stuff:oops"
    end
  end

  describe '#smas' do 
    it 'should be an alias for serialization'
  end
end

describe SymbolMatrix do
  it 'should include the Discoverer for Writer' do 
    SymbolMatrix.ancestors.should include Discoverer::Writer
  end
end
