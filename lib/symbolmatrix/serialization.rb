class SymbolMatrix < Hash
  class Serialization
    def self.parse serialization
      result = SymbolMatrix.new
      if serialization.include? " "
        serialization.split(" ").each do |command|
          result = result.recursive_merge parse command
        end
      else
        parts = serialization.split ":"
        unless parts.first.include? "."          
          result.merge! parts.first => parts.last
        else
          the_key = serialization[0..serialization.index(".") -1]
          result[the_key] = parse serialization[serialization.index(".")+1..-1]
        end
      end
      result
    end
  end
end