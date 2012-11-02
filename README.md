SymbolMatrix
============

[![Build Status](https://secure.travis-ci.org/Fetcher/symbolmatrix.png)](http://travis-ci.org/Fetcher/symbolmatrix) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/Fetcher/symbolmatrix)

> Strongly inspired in [SymbolTable][symboltable] gem by [Michael Jackson][michael-jackson-home] (thanks a lot!)

**SymbolMatrix** is a simple Ruby Gem that extends `Hash` so that only `Symbol`s can be used as keys. Why? Because it also allows you to query the SymbolMatrix object using the dot syntax and a string key equivalent to the symbol one, making it more Principle of Least Surprise.

The showdown:

```ruby
h = Hash.new
h[:a] = 1
h[:a]       # => 1
h['a']      # => nil
h.a         # => NoMethodError: undefined method `a' for {}:Hash

require 'symbolmatrix'

m = SymbolMatrix.new
m[:a] = 1
m[:a]       # => 1
m['a']      # => 1
m.a         # => 1
```

If you are familiar with SymbolTable you may have noticed that, so far, the same functionality is provided in the original gem. SymbolMatrix adds two key features:

1.  **Recursive convertion to SymbolMatrix**

    ```ruby
    require "symbolmatrix"
    
    m = SymbolMatrix.new :quantum => { :nano => "data" }

    m.quatum.nano # => "data"
    ```

2.  **JSON/YAML autoloading**
    
    ```ruby
    require "symbolmatrix"
    
    m = SymbolMatrix.new "quantum: of solace"
    m.quantum   # => "of solace"
    
    # Or alternatively
    m.from_yaml "quantum: of solace"
    
    # Provided a file exists "configuration.yaml" with "database_uri: mysql://root@localhost/database"
    m.from_file "configuration.yaml"
    m.database_uri  # => "mysql://root@localhost/database"
    
    # Or simply
    m = SymbolMatrix.new "configuration.yaml"
    ```
    
    Since all JSON is valid YAML... yey, it works with JSON too!
	```ruby
    require 'symbolmatrix'
    
    data = SymbolMatrix.new '{"message":"Awesome"}'
    data.message # => 'Awesome'
    ```

[symboltable]: https://github.com/mjijackson/symboltable
[michael-jackson-home]: http://mjijackson.com/

Further details
---------------

### Recursive `#to_hash` convertion

SymbolMatrix provides the `#to_hash` method that recursively transforms the matrix into a n-dimentional Hash.

### Disabling the YAML discovery

If for some reason you don't want this class to use YAML, you can just require `symbolmatrix/symbolmatrix` and the YAML functionality will not be loaded.

### Exceptions

Whenever a key is not found in the SymbolMatrix, a custom `SymbolMatrix::KeyNotDefinedException` will be raised. 
Similarly, if you attempt to use an inconvertible key (inconvertible to `Symbol`) a `SymbolMatrix::InvalidKeyException` will be raised.

Installation
------------

    gem install symbolmatrix

### Or using Bundler
Add this line to your application's Gemfile:

    gem 'symbolmatrix'

And then execute:

    bundle install

## Known issues

- When loading a YAML/JSON document that has an sequence &ndash;array&ndash; as the root item, SymbolMatrix will crash. This is because SymbolMatrix wasn't intended for arrays, just Hashes, and the recursive conversion from Hash to SymbolMatrix is not working with Arrays.

## Future

- Make SymbolMatrix raise a more relevant error when the file does not exist (something along the lines of "There was an error parsing the YAML string, may be it was a file path and the file does not exist?"). It is possible to increase the chances of detecting properly with a really simple regular expression...

## Testing

RSpec specs are provided to check functionality.

## License

Copyright (C) 2012 Fetcher

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
