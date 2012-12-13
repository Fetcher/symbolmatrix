require 'complete_features_helper'

describe YAML::SymbolMatrix do
  describe "#from_yaml" do
    it "should call #merge! on self using the parsed YAML data as argument" do
      sample_yaml = "a: { nested: { data: with, very: much }, content: to find }"
      the_stub = stub "a theoretical SymbolMatrix"
      the_stub.extend YAML::SymbolMatrix
      the_stub.should_receive(:merge!).with "a" => { "nested" => { "data" => "with", "very" => "much" }, "content" => "to find" }
      the_stub.from_yaml sample_yaml
    end
  end
  
  describe "#from_file" do
    context "there is a YAML file in the given path" do
      before do
        Fast.file.write "temp/data.yaml", "a: { nested: { data: with, very: much }, content: to find }"
      end
      
      it "should call #merge! on self using the parsed YAML data found in the file" do
        the_stub = stub "a theoretical SymbolMatrix"
        the_stub.extend YAML::SymbolMatrix
        the_stub.should_receive(:merge!).with "a" => { "nested" => { "data" => "with", "very" => "much" }, "content" => "to find" }
        the_stub.from_file "temp/data.yaml"
      end
      
      after do
        Fast.dir.remove! :temp
      end
    end
  end
end

describe SymbolMatrix do
  describe "#initialize" do # Soooooo meta... tell me its true!
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
  end
end
