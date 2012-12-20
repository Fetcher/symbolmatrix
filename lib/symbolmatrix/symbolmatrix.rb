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
  
  # @deprecated Use #to.hash instead
  def to_hash 
    Kernel.warn "[DEPRECATION]: #to_hash is deprecated, please use #to.hash instead"
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
  def recursive_merge hash, override = false
    result = SymbolMatrix.new
    self.keys.each do |key|
      result[key] = self[key]
    end

    hash.keys.each do |key|
      if result.has_key? key
        if result[key].respond_to? :recursive_merge
          result[key] = result[key].recursive_merge hash[key], override
        else
          if override
            result[key] = hash[key]
          else
            raise MergeError, "The value of the :#{key} key is already defined. Run recursive merge with flag true if you want it to override"
          end
        end
      else
        result[key] = hash[key]
      end
    end
    return result
  end

  # Merges recursively the passed SymbolMatrix into self
  def recursive_merge! symbolmatrix, override = false
    symbolmatrix.each do |key, value|
      if self.has_key? key
        if self[key].respond_to? :recursive_merge!
          self[key].recursive_merge! value, override
        else
          if override
            self[key] = value
          else
            raise MergeError, "The value of the :#{key} key is already defined. Run recursive merge with flag true if you want it to override"
          end
        end
      else 
        self[key] = value
      end
    end
  end

  class KeyNotDefinedException < RuntimeError; end
  class InvalidKeyException < RuntimeError; end 
  class MergeError < RuntimeError; end 
end

def SymbolMatrix *args
  SymbolMatrix.new *args
end