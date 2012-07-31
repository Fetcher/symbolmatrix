require "yaml"

module YAML
  module SymbolMatrix
    # Calls #merge! using the parsed YAML data as argument
    def from_yaml yaml
      merge! YAML.load yaml
    end
    
    # Calls #merge! using the parsed YAML data from the file
    def from_file path
      merge! YAML.load_file path
    end
    
    # Can I override initialize and call super anyways??
    def initialize argument = nil
      if argument.nil?
        super
      else
        if argument.is_a? String
          if File.exist? argument
            from_file argument
          else
            from_yaml argument
          end
        else
          super argument
        end
      end
    end
  end
end

class SymbolMatrix
  include YAML::SymbolMatrix
end
