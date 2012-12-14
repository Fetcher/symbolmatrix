require "symbolmatrix/version"

class SymbolMatrix < Hash

  # Initializes the SymbolMatrix with the passed Hash if a hash is passed
  def initialize hash = nil
    super
    merge! hash unless hash.nil?
  end

  # Validates whether the given key is usable in a SymbolMatrix
  def validate_key key
    unless key.respond_to? :to_sym
      raise InvalidKeyException, "The key '#{key}' does not respond to #to_sym, so is not a valid key for SymbolMatrix"
    end
      
    return true
  end

  # Sets the value of the given +key+ to +val+ if the key is valid.
  def store key, val
    validate_key key
    if val.instance_of? Hash
      super(key.to_sym, SymbolMatrix.new(val))
    else
      super(key.to_sym, val)
    end
  end

  # Retrieves the value of the given +key+.
  def [] key
    validate_key key
    raise KeyNotDefinedException, "The key :#{key} is not defined" unless self.has_key? key.to_sym
    super key.to_sym
  end

  alias []= store  
  
  # Returns a hashed version of this SymbolMatrix, with all SymbolMatrix objects within recursively 
  # converted into hashes
  def to_hash recursive = true
    the_hash = {}
    self.each do |key, value|
      if value.is_a? SymbolMatrix and recursive
        the_hash[key] = value.to_hash
      else
        the_hash[key] = value
      end
    end
    return the_hash
  end
  
  # Merges the passed hash within self
  def merge! hash
    hash.each do |key, value|
      store key, value
    end
  end
  
  alias update merge!
  
  # Checks the keys for compatibility with SymbolMatrix and calls the merge in Hash
  def merge hash
    # Before merging, let's check the keys
    hash.each_key do |key|
      validate_key key
    end
    super hash
  end

  # Allows values to be retrieved and set using Ruby's dot method syntax.
  def method_missing sym, *args
    if sym.to_s.index "="
      store sym.to_s[0..-2].to_sym, args.shift
    else
      self[sym]
    end
  end
  
  # Merges this SymbolMatrix with another SymbolMatrix recursively
  def recursive_merge hash
    result = SymbolMatrix.new
    self.keys.each do |key|
      result[key] = self[key]
    end

    hash.keys.each do |key|
      if result.has_key? key
        result[key] = result[key].recursive_merge hash[key]
      else
        result[key] = hash[key]
      end
    end
    return result
  end

  class KeyNotDefinedException < RuntimeError; end
  class InvalidKeyException < RuntimeError; end 
end
