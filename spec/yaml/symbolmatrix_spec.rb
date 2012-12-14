require 'complete_features_helper'

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
