require 'complete_features_helper'

describe SymbolMatrix::Serialization do
  describe '.parse' do 
    it 'should parse an empty string' do 
      sm = SymbolMatrix::Serialization.parse ""
      sm.keys.should be_empty
    end

    it 'should parse a simple string aja:hola' do
      sm = SymbolMatrix::Serialization.parse 'aja:hola'
      sm.aja.should == 'hola'
    end

    it 'should parse another simple string esto:distinto' do 
      SymbolMatrix::Serialization
        .parse('esto:distinto')
        .esto.should == "distinto"
    end

    it 'should parse to a number when is a number' do
      SymbolMatrix::Serialization
        .parse("esto:3442")
        .esto.should == 3442
    end

    it 'should parse a more complex string' do 
      sm = SymbolMatrix::Serialization.parse 'hola:eso que:pensas'
      sm.hola.should == 'eso'
      sm.que.should == 'pensas'
    end

    it 'should parse another complex string' do 
      sm = SymbolMatrix::Serialization
        .parse("esto:es bastante:original gracias:bdd")
      sm.esto.should == "es"
      sm.bastante.should == "original"
      sm.gracias.should == "bdd"
    end

    it 'should parse a string with a single dot' do 
      SymbolMatrix::Serialization
        .parse("just.one:dot")
        .just.one.should == "dot"
    end

    it 'should parse another string with single dot' do 
      SymbolMatrix::Serialization
        .parse("just.one:point")
        .just.one.should == "point"
    end

    it 'should parse another one, other var name' do 
      SymbolMatrix::Serialization
        .parse("just.another:data")
        .just.another.should == "data"
    end

    it 'should parse a string with dots' do
      SymbolMatrix::Serialization
        .parse("the.one.with:dots")
        .the.one.with.should == "dots"
    end

    it 'should parse a string with dots and spaces' do
      sm = SymbolMatrix::Serialization
        .parse("in.one.with:dots the.other.with:dots")
      sm.the.other.with.should == "dots"
      sm.in.one.with.should == "dots"
    end    

    it 'should merge recursively when needed' do 
      sm = SymbolMatrix::Serialization
        .parse("client.host:localhost client.path:hola")

      sm.client.host.should == "localhost"
      sm.client.path.should == "hola"
    end
  end
end

describe SymbolMatrix do
  describe "#initialize" do
    context "a valid path to a file is provided" do
      before do 
        Fast.file.write "temp/data.yaml", "a: { nested: { data: with, very: much }, content: to find }"
      end
      
      it "should load the data into self" do
        f = SymbolMatrix.new "temp/data.yaml"
        f.a.nested.data.should == "with"
      end

      after do
        Fast.dir.remove! :temp
      end
    end
    
    context "a YAML string is provided" do
      it "should load the data into self" do
        e = SymbolMatrix.new "beta: { nano: { data: with, very: much }, content: to find }"
        e.beta.nano[:very].should == "much"
      end
    end

    context "a SymbolMatrix serialization is provided" do 
      it 'should load the data into self' do 
        a = SymbolMatrix.new "those.pesky:attempts of.making.it:work"
        a.those.pesky.should == "attempts"
        a.of.making.it.should == "work"
      end
    end

    context "an empty string is provided" do
      it 'should load nothing into the SymbolMatrix' do 
        a = SymbolMatrix ""
        a.keys.should be_empty
      end
    end
  end
end