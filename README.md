# Parsed

Parses files into basic Ruby objects. Currently only the JSON format is
supported. Future versions are planned to support XML, Haml and TOML.

## Why

TODO: Write rationale behind gem.

## Installation

Add this line to your application's Gemfile:

    gem 'parsed'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parsed

## How do I use it?

Say, you have the following configuration file containing your favorite
superhero:

``` json
# superhero.json
{ "name": "Spider-Man" }
```

In order to load this data into your program, you need to add the
`Parsed::Parseable` module to the class you want to load the data:

``` ruby
# file: superhero.rb
class Superhero
  include Parsed::Parseable
  attr_accessor :name
end
```

Sending the `parse`-method with the configuration as a parameter to the
`Superhero` class will return a `Superhero` instance:

``` ruby
superhero = Superhero.parse(File.read('superhero.json'))

p superhero.name
# => "Spider-Man"
```

**What if my file contains a field that is not present in the class?**

It will be ignored when parsing the file, as you can see in the following
example:

``` json
# superhero.json
{ "name": "Hulk", "power": "Superhuman strength" }
```

``` ruby
superhero = Superhero.parse(File.read('superhero.json'))

p superhero.power
# => NoMethodError: undefined method `power' for #<Superhero:0x007ff2120f7920>
```

This works both ways, so you can have attributes on your model that are not
present in the configuration file.

**What if I have more than one element to parse?**

No problem! You probably have multiple superheroes you like, right? Your
configuration file might look something like this:

``` json
# superheroes.json
[{ "name": "Spider-Man" },
 { "name": "Thor" },
 { "name": "Hulk" },
 { "name": "Iron Man" }]
```

In order to load this data, you can re-use the same `Superhero` class definition
from before.

Sending the `parse`-method with the configuration as a parameter to the
`Superhero` class will return an array of `Superhero` instances:

``` ruby
superheroes = Superhero.parse(File.read('superheroes.json'))

p superheroes.size
# => 4

p superheroes.first.name
# => "Spider-Man"
```

**Sounds good. How about associations?**

**TODO** Write example.

**You only have been working with text so far. How about parsing dates or
integer values?**

**TODO**

``` json
# superhero.json
{
  "name": "Spider-Man",
  "strength": "20"
}
```

``` ruby
# superhero.rb
class Superhero
  include Parsed::Parseable

  attr_accessor :name, :age

  parseable do
    text    :name
    integer :age
  end

end
```

Fields that cannot be converted to the specific data types will be ignored.

**Help! The fields in my configuration file have a different name than the
attributes on the model.**

Ok, so maybe you have something like this:

``` json
# superhero.json
{
  "NAME": "Spider-Man"
}
```

You can define a mapping from your configuration file to a particular attribute
using the `from` option when defining a parseable field in the `parseable`
block.

``` ruby
# superhero.rb
class Superhero
  include Parsed::Parseable

  attr_accessor :name

  parseable do
    text :name, from: "NAME"
  end

end
```

## Roadmap

* Provide configuration parameter to be able to log or raise errors when
  detecting a field that we are unable to parse.
* Add logging.
* Replace rspec integration tests by Cucumber features and hook them up to
  Relishapp.
* Implement DSL idea from
  http://blog.joecorcoran.co.uk/2013/09/04/simple-pattern-ruby-dsl/
* Write more documentation.
* Implement different parsers: XML, YAML, TOML, etc.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
