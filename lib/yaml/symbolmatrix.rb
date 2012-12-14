class SymbolMatrix < Hash
  def initialize argument = nil
    if argument.is_a? String
      if File.exist? argument
        from.file argument
      else
        from.yaml argument
      end
    else
      merge! argument unless argument.nil?
    end
  end
end
