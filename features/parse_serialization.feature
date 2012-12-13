Feature: Parsing a SymbolMatrix serialization
  In order to be able to build multidimensional hashes from 
    single line contexts, such as terminals
  As a developer
  I want to have a simple way to parse a serialization

Scenario: Quite basic structure
  Given "data:datum"
  When I parse it
  Then I should see (serialized in yaml)
  """
  data: datum
  """