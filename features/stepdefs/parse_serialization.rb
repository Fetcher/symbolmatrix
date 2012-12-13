Given /^"(.+?)"$/ do |serialization|
  @serialization = serialization
end

When /^I parse it$/ do 
  @parsed = SymbolMatrix.new.from.serialization @serialization
end