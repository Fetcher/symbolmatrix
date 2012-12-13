require 'complete_features_helper'

describe SymbolMatrix do
  it 'should include the Discoverer for Reader' do 
    SymbolMatrix.ancestors.should include Discoverer::Reader
  end
end
