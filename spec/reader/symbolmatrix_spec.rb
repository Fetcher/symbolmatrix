require 'complete_features_helper'

describe Reader::SymbolMatrix do
  describe '#initialize' do
    it 'receives a source and add it as source' do
      source = double 'source'
      reader = Reader::SymbolMatrix.new source
      expect(reader.source).to eq source
    end
  end

  describe "#yaml" do
    it "calls #merge! the source using the parsed YAML data as argument" do
      sample_yaml = "a: { nested: { data: with, very: much }, content: to find }"
      the_stub = double "a theoretical SymbolMatrix"
      reader = Reader::SymbolMatrix.new the_stub
      expect(the_stub).to receive(:merge!).with "a" => { "nested" => { "data" => "with", "very" => "much" }, "content" => "to find" }
      reader.yaml sample_yaml
    end
  end

  describe "#file" do
    context "there is a YAML file in the given path" do
      before do
        Fast.file.write "temp/data.yaml", "a: { nested: { data: with, very: much }, content: to find }"
      end

      it "calls #merge! on the source using the parsed YAML data found in the file" do
        the_stub = double "a theoretical SymbolMatrix"
        reader = Reader::SymbolMatrix.new the_stub
        expect(the_stub).to receive(:merge!).with "a" => { "nested" => { "data" => "with", "very" => "much" }, "content" => "to find" }
        reader.file "temp/data.yaml"
      end

      after do
        Fast.dir.remove! :temp
      end
    end
  end

  shared_examples_for "any reader serialization" do
    it 'calls merge! to source with the parsed data' do
      the_sm = double 'sm'
      data_stub = double 'data'
      ready_to_merge = double 'ready to merge'
      reader = Reader::SymbolMatrix.new the_sm
      expect(SymbolMatrix::Serialization).to receive(:parse).with(data_stub).and_return ready_to_merge
      expect(the_sm).to receive(:merge!).with ready_to_merge
      reader.send @method, data_stub
    end
  end

  describe "#serialization" do
    before { @method = :serialization }
    it_behaves_like 'any reader serialization'
  end

  describe '#smas' do
    before { @method = :smas }
    it_behaves_like 'any reader serialization'
  end
end

describe SymbolMatrix do
  it 'includes the Discoverer for Reader' do
    expect(SymbolMatrix.ancestors).to include Discoverer::Reader
  end

  it 'features a deprecation notice in #from_yaml' do
    expect(Kernel).to receive(:warn).with "[DEPRECATION]: #from_yaml is deprecated, please use #from.yaml instead"
    SymbolMatrix.new.from_yaml double 'argument'
  end

  it 'features a deprecation notice in #from_file' do
    expect(Kernel).to receive(:warn).with "[DEPRECATION]: #from_file is deprecated, please use #from.file instead"
    SymbolMatrix.new.from_file double 'argument'
  end
end
