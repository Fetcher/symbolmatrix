Given /^"(.+?)"$/ do |serialization|
  @serialization = serialization
end

When /^I parse it$/ do 
  @parsed = SymbolMatrix.new.from.serialization @serialization
end

Then /^I should see \(serialized in yaml\)$/ do |data|
  @parsed.to_hash.should include SymbolMatrix.new(data).to_hash
end