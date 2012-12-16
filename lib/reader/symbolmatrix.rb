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

    alias :smas :serialization
  end
end

class SymbolMatrix < Hash
  include Discoverer::Reader

  # @deprecated Use #from.yaml
  def from_yaml *args
    Kernel.warn "[DEPRECATION]: #from_yaml is deprecated, please use #from.yaml instead"
  end

  # @deprecated Use #from.file
  def from_file *args
    Kernel.warn "[DEPRECATION]: #from_file is deprecated, please use #from.file instead"
  end
end