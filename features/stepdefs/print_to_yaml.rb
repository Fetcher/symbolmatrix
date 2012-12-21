When /^I write it to YAML$/ do 
  @yaml = @symbolmatrix.to.yaml
end

Then /^I should have$/ do |yaml|
  @yaml.should == yaml
end