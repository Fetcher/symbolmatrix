Feature: Print to YAML
  I want to be able to print a SymbolMatrix into YAML
    with a simple Hash format

Scenario: A simple SymbolMatrix
  Given the SymbolMatrix:
  """
  a:
    simple: symbolmatrix
    with: data
  """
  When I write it to YAML
  Then I should have
  """
  ---
  a:
    simple: symbolmatrix
    with: data
  
  """