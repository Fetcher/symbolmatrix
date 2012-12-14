module Reader
  class SymbolMatrix
    attr_accessor :source

    def initialize source
      @source = source
    end

    def file path
      @source.merge! YAML.load_file path
    end

    def yaml data
      @source.merge! YAML.load data
    end

    def serialization data
      @source.merge! ::SymbolMatrix::Serialization.parse data
    end
  end
end

class SymbolMatrix < Hash
  include Discoverer::Reader
end