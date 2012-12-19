class SymbolMatrix < Hash
  class Serialization
    def self.parse serialization
      result = SymbolMatrix.new
      return result if serialization.length == 0
      
      if serialization.include? " "
        serialization.split(" ").each do |command|
          result = result.recursive_merge parse command
        end
      else
        parts = serialization.split ":"
        unless parts.first.include? "."          
          begin
            parts[1] = Integer parts.last
          rescue ArgumentError => e
          end
          result.merge! parts.first => parts.last
        else
          the_key = serialization[0..serialization.index(".") -1]
          result[the_key] = parse serialization[serialization.index(".")+1..-1]
        end
      end
      result
    end
  end

  def initialize argument = nil
    if argument.is_a? String
      if File.exist? argument
        from.file argument
      else
        begin
          from.yaml argument
        rescue NoMethodError => e
          from.serialization argument
        end
      end
    else
      merge! argument unless argument.nil?
    end
  end
end
