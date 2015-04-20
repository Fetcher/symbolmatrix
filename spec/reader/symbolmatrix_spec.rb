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
    shared_examples_for "parsed YAML" do
      it "calls #merge! the source using the parsed YAML data as argument" do
        the_stub = double "a theoretical SymbolMatrix"
        reader = Reader::SymbolMatrix.new the_stub
        expect(the_stub).to receive(:merge!).with parsed_hash
        reader.yaml sample_yaml
      end
    end

    context "with YAML" do
      let(:sample_yaml) { "a: { nested: { data: with, very: much }, content: to find }" }
      let(:parsed_hash) {
        {
          "a" => {
            "nested" => {
              "data" => "with",
              "very" => "much"
            },
            "content" => "to find"
          }
        }
      }

      it_behaves_like "parsed YAML"
    end

    context "with YAML containing ERB" do
      let(:sample_yaml) { "a: { nested: { data: with, very: much }, content: <%= 'to find' %> }" }
      let(:parsed_hash) {
        {
          "a" => {
            "nested" => {
              "data" => "with",
              "very" => "much"
            },
            "content" => "to find"
          }
        }
      }

      it_behaves_like "parsed YAML"
    end
  end

  describe "#file" do
    shared_examples_for "parsed file" do
      let(:path) { File.join('temp', file) }

      around do |example|
        Fast.file.write path, yaml
        example.run
        Fast.dir.remove! :temp
      end

      it "calls #merge! on the source using the parsed YAML data found in the file" do
        the_stub = double "a theoretical SymbolMatrix"
        reader = Reader::SymbolMatrix.new the_stub
        expect(the_stub).to receive(:merge!).with parsed_hash
        reader.file path
      end
    end

    context "there is a YAML file in the given path" do
      let(:file) { 'data.yaml' }
      let(:yaml) { "a: { nested: { data: with, very: much }, content: to find }" }
      let(:parsed_hash) {
        {
          "a" => {
            "nested" => {
              "data" => "with",
              "very" => "much"
            },
            "content" => "to find"
          }
        }
      }

      it_behaves_like "parsed file"
    end

    context "there is a YAML file with ERB in the given path" do
      let(:file) { 'data.yaml' }
      let(:yaml) { "a: { nested: { data: with, very: much }, content: <%= 'to find' %> }" }
      let(:parsed_hash) {
        {
          "a" => {
            "nested" => {
              "data" => "with",
              "very" => "much"
            },
            "content" => "to find"
          }
        }
      }

      it_behaves_like "parsed file"
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
