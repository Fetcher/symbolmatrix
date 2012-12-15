require 'complete_features_helper'

describe Reader::SymbolMatrix do 
  describe '#initialize' do 
    it 'should receive a source and add it as source' do 
      source = stub 'source'
      reader = Reader::SymbolMatrix.new source
      reader.source.should == source
    end
  end

  describe "#yaml" do
    it "should call #merge! the source using the parsed YAML data as argument" do
      sample_yaml = "a: { nested: { data: with, very: much }, content: to find }"
      the_stub = stub "a theoretical SymbolMatrix"
      reader = Reader::SymbolMatrix.new the_stub
      the_stub.should_receive(:merge!).with "a" => { "nested" => { "data" => "with", "very" => "much" }, "content" => "to find" }
      reader.yaml sample_yaml
    end
  end
  
  describe "#file" do
    context "there is a YAML file in the given path" do
      before do
        Fast.file.write "temp/data.yaml", "a: { nested: { data: with, very: much }, content: to find }"
      end
      
      it "should call #merge! on the source using the parsed YAML data found in the file" do
        the_stub = stub "a theoretical SymbolMatrix"
        reader = Reader::SymbolMatrix.new the_stub
        the_stub.should_receive(:merge!).with "a" => { "nested" => { "data" => "with", "very" => "much" }, "content" => "to find" }
        reader.file "temp/data.yaml"
      end
      
      after do
        Fast.dir.remove! :temp
      end
    end
  end

  describe "#serialization" do 
    it 'should call merge! to source with the parsed data' do 
      the_sm = stub 'sm'
      data_stub = stub 'data'
      ready_to_merge = stub 'ready to merge'
      reader = Reader::SymbolMatrix.new the_sm
      SymbolMatrix::Serialization.should_receive(:parse).with(data_stub).and_return ready_to_merge
      the_sm.should_receive(:merge!).with ready_to_merge
      reader.serialization data_stub
    end
  end

  describe '#smas' do 
    it 'should be an alias for #serialization'
  end
end

describe SymbolMatrix do
  it 'should include the Discoverer for Reader' do 
    SymbolMatrix.ancestors.should include Discoverer::Reader
  end

  it 'should feature a deprecation notice in #from_yaml'

  it 'should feature a deprecation notice in #from_file'
end
