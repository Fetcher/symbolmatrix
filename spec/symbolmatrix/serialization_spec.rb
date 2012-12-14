require 'complete_features_helper'

describe SymbolMatrix::Serialization do
  describe '.parse' do 
    it 'should parse a simple string aja:hola' do
      sm = SymbolMatrix::Serialization.parse 'aja:hola'
      sm.aja.should == 'hola'
    end

    it 'should parse another simple string esto:distinto' do 
      SymbolMatrix::Serialization
        .parse('esto:distinto')
        .esto.should == "distinto"
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