module Writer
  class SymbolMatrix
    attr_accessor :source

    def initialize source
      @source = source
    end

    def serialization prefix = nil
      result = ""
      @source.each do |key, value|
        unless value.is_a? Hash
          result += " #{prefix}#{key}:#{value}"
        else
          result += " " + Writer::SymbolMatrix.new(value).serialization("#{prefix}#{key}.")
        end
      end
      result[1..-1]
    end
  end
end

class SymbolMatrix < Hash
  include Discoverer::Writer
end