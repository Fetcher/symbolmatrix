require 'complete_features_helper'

describe Writer::SymbolMatrix do
  describe '#initialize' do
    it 'sets the argument as the source' do
      source = double 'source'
      writer = Writer::SymbolMatrix.new source
      expect(writer.source).to eq source
    end
  end

  describe '#hash' do
    it "returns an instance of Hash" do
      m = SymbolMatrix[:b, 1]
      writer = Writer::SymbolMatrix.new m
      expect(writer.hash).to be_instance_of Hash
    end

    it "has the same keys" do
      m = SymbolMatrix[:a, 1]
      writer = Writer::SymbolMatrix.new m
      expect(writer.hash[:a]).to eq 1
    end

    it "has the same keys (more keys)" do
      m = SymbolMatrix[:a, 2]
      writer = Writer::SymbolMatrix.new m
      expect(writer.hash[:a]).to eq 2
    end

    context "there is some SymbolMatrix within this SymbolMatrix" do
      it "recursively calls #to.hash in it" do
        in_writer = double 'inside writer'

        inside = SymbolMatrix.new
        expect(inside).to receive(:to).and_return in_writer
        expect(in_writer).to receive(:hash)

        m = SymbolMatrix[:a, inside]
        writer = Writer::SymbolMatrix.new m
        writer.hash
      end
    end
  end

  shared_examples_for 'any writer serialization' do
    it 'serializes "try: this" into "try:this"' do
      s = SymbolMatrix try: "this"
      writer = Writer::SymbolMatrix.new s
      expect(writer.send(@method)).to eq "try:this"
    end

    it 'serializes "try: that" into "try:that"' do
      s = SymbolMatrix try: "that"
      expect(
        Writer::SymbolMatrix
          .new(s).send(@method)
      ).to eq "try:that"
    end

    it 'serializes "attempt: this" into "attempt:this"' do
      expect(
        Writer::SymbolMatrix
          .new(SymbolMatrix(attempt: "this"))
          .send(@method)
      ).to eq "attempt:this"
    end

    it 'serializes "attempt: that" into "attempt:that"' do
      expect(
        Writer::SymbolMatrix
          .new(SymbolMatrix(attempt: "that"))
          .send(@method)
      ).to eq "attempt:that"
    end

    it 'serializes a more complex hash' do
      expect(
        Writer::SymbolMatrix
          .new(SymbolMatrix(a: "b", c: "d"))
          .send(@method)
      ).to eq "a:b c:d"
    end

    it 'serializes a more complex hash with different values' do
      expect(
        Writer::SymbolMatrix
          .new(SymbolMatrix(g: "e", r: "t"))
          .send(@method)
      ).to eq "g:e r:t"
    end

    it 'serializes a multidimentional hash' do
      expect(
        Writer::SymbolMatrix
          .new(SymbolMatrix(g: {e: "s"}))
          .send(@method)
      ).to eq "g.e:s"
    end

    it 'serializes a different multidimentional hash' do
      expect(
        Writer::SymbolMatrix
          .new(SymbolMatrix(r: {e: "s"}))
          .send(@method)
      ).to eq "r.e:s"
    end

    it 'serializes a yet different multidimentional hash' do
      expect(
        Writer::SymbolMatrix
          .new(SymbolMatrix(r: {a: "s"}))
          .send(@method)
      ).to eq "r.a:s"
    end

    it 'serializes a more complex multidimentional hash' do
      expect(
        Writer::SymbolMatrix
          .new(SymbolMatrix(r: {a: "s", f: "o"}))
          .send(@method)
      ).to eq "r.a:s r.f:o"
    end

    it 'serializes a different more complex multidimentional hash' do
      expect(
        Writer::SymbolMatrix
          .new(SymbolMatrix(r: {ar: "s", fe: "o"}))
          .send(@method)
      ).to eq "r.ar:s r.fe:o"
    end

    it 'serializes a yet different more complex multidimentional hash' do
      expect(
        Writer::SymbolMatrix
          .new(SymbolMatrix(r: {ar: "s", fe: "o", wh: "at"}))
          .send(@method)
      ).to eq "r.ar:s r.fe:o r.wh:at"
    end

    it 'serializes a more complex multidimentional hash' do
      expect(
        Writer::SymbolMatrix
          .new(SymbolMatrix(r: {a: { f: "o", s: "h", y: "u"}}))
          .send(@method)
      ).to eq "r.a.f:o r.a.s:h r.a.y:u"
    end

    it 'transforms the multidimentional hash into a simple dot and colons serialization' do
      multidimentional = SymbolMatrix.new hola: {
          the: "start",
          asdfdf: 8989,
          of: {
            some: "multidimentional"
          }
        },
        stuff: "oops"

      writer = Writer::SymbolMatrix.new multidimentional
      expect(writer.send(@method)).to eq "hola.the:start hola.asdfdf:8989 hola.of.some:multidimentional stuff:oops"
    end
  end

  describe '#serialization' do
    before { @method = :serialization }
    it_behaves_like 'any writer serialization'
  end

  describe '#smas' do
    before { @method = :smas }
    it_behaves_like 'any writer serialization'
  end

  describe '#json' do
    it 'returns a json serialization' do
      sm = SymbolMatrix alpha: { beta: "gamma" }
      writer = Writer::SymbolMatrix.new sm
      expect(writer.json).to eq '{"alpha":{"beta":"gamma"}}'
    end
  end

  describe '#yaml' do
    it 'returns a yaml serialization' do
      sm = SymbolMatrix alpha: { beta: "gamma" }
      writer = Writer::SymbolMatrix.new sm
      expect(writer.yaml).to include "alpha:\n  beta: gamma"
    end
  end

  describe '#string_key_hash' do
    it 'converts a SymbolMatrix to a multidimentional hash with all string keys' do
      sm = SymbolMatrix alpha: { beta: "gamma" }
      writer = Writer::SymbolMatrix.new sm
      expect(writer.string_key_hash)
        .to eq({ "alpha" => { "beta" => "gamma"} })
    end
  end
end

describe SymbolMatrix do
  it 'includes the Discoverer for Writer' do
    expect(SymbolMatrix.ancestors).to include Discoverer::Writer
  end
end
