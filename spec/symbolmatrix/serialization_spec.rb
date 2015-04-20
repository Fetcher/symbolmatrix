require 'complete_features_helper'

describe SymbolMatrix::Serialization do
  describe '.parse' do
    it 'parses an empty string' do
      sm = SymbolMatrix::Serialization.parse ""
      expect(sm.keys).to be_empty
    end

    it 'parses a simple string aja:hola' do
      sm = SymbolMatrix::Serialization.parse 'aja:hola'
      expect(sm.aja).to eq 'hola'
    end

    it 'parses another simple string esto:distinto' do
      expect(
        SymbolMatrix::Serialization
          .parse('esto:distinto')
          .esto
      ).to eq "distinto"
    end

    it 'parses to a number when is a number' do
      expect(
        SymbolMatrix::Serialization
          .parse("esto:3442")
          .esto
      ).to eq 3442
    end

    it 'parses a more complex string' do
      sm = SymbolMatrix::Serialization.parse 'hola:eso que:pensas'
      expect(sm.hola).to eq 'eso'
      expect(sm.que).to eq 'pensas'
    end

    it 'parses another complex string' do
      sm = SymbolMatrix::Serialization
        .parse("esto:es bastante:original gracias:bdd")
      expect(sm.esto).to eq "es"
      expect(sm.bastante).to eq "original"
      expect(sm.gracias).to eq "bdd"
    end

    it 'parses a string with a single dot' do
      expect(
        SymbolMatrix::Serialization
          .parse("just.one:dot")
          .just.one
      ).to eq "dot"
    end

    it 'parses another string with single dot' do
      expect(
        SymbolMatrix::Serialization
          .parse("just.one:point")
          .just.one
      ).to eq "point"
    end

    it 'parses another one, other var name' do
      expect(
        SymbolMatrix::Serialization
          .parse("just.another:data")
          .just.another
      ).to eq "data"
    end

    it 'parses a string with dots' do
      expect(
        SymbolMatrix::Serialization
          .parse("the.one.with:dots")
          .the.one.with
      ).to eq "dots"
    end

    it 'parses a string with dots and spaces' do
      sm = SymbolMatrix::Serialization
        .parse("in.one.with:dots the.other.with:dots")
      expect(sm.the.other.with).to eq "dots"
      expect(sm.in.one.with).to eq "dots"
    end

    it 'merges recursively when needed' do
      sm = SymbolMatrix::Serialization
        .parse("client.host:localhost client.path:hola")

      expect(sm.client.host).to eq "localhost"
      expect(sm.client.path).to eq "hola"
    end
  end
end

describe SymbolMatrix do
  describe "#initialize" do
    context "a valid path to a file is provided" do
      before do
        Fast.file.write "temp/data.yaml", "a: { nested: { data: with, very: much }, content: to find }"
      end

      it "loads the data into self" do
        f = SymbolMatrix.new "temp/data.yaml"
        expect(f.a.nested.data).to eq "with"
      end

      after do
        Fast.dir.remove! :temp
      end
    end

    context "a YAML string is provided" do
      it "loads the data into self" do
        e = SymbolMatrix.new "beta: { nano: { data: with, very: much }, content: to find }"
        expect(e.beta.nano[:very]).to eq "much"
      end
    end

    context "a SymbolMatrix serialization is provided" do
      it 'loads the data into self' do
        a = SymbolMatrix.new "those.pesky:attempts of.making.it:work"
        expect(a.those.pesky).to eq "attempts"
        expect(a.of.making.it).to eq "work"
      end
    end

    context "an empty string is provided" do
      it 'loads nothing into the SymbolMatrix' do
        a = SymbolMatrix ""
        expect(a.keys).to be_empty
      end
    end
  end
end