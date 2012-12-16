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

    alias :smas :serialization

    def hash
      the_hash = {}
      @source.each do |key, value|
        if value.respond_to? :to
          the_hash[key] = value.to.hash
        else
          the_hash[key] = value
        end
      end
      the_hash
    end
  end
end

class SymbolMatrix < Hash
  include Discoverer::Writer
end