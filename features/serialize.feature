Feature: Serializing a SymbolMatrix
  In order to be able to send SymbolMatrices
    in command line environments
  As a developer
  I want to be able to serialize SymbolMatrices

Scenario: Nice SymbolMatrix serialized
  Given the SymbolMatrix:
  """
  roses:
    are: red
  violets:
    are: blue
  I:
    get: joke
    like: poetry
    say: 
      to: you
      some: stuff
  """
  When I serialize it
  Then I should get "roses.are:red violets.are:blue I.get:joke I.like:poetry I.say.to:you I.say.some:stuff"

Scenario: Serializing and parsing back
  Given the SymbolMatrix:
  """
  greetings:
    aloha: hawaii
  cities:
    roma: italy
    paris: france
  """
  When I serialize it
  Then I should get "greetings.aloha:hawaii cities.roma:italy cities.paris:france"
  When I parse it
  Then I should see (serialized in yaml)
  """
  greetings:
    aloha: hawaii
  cities:
    roma: italy
    paris: france
  """