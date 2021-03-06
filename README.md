# Parsed

[![Build Status](https://travis-ci.org/robinroestenburg/parsed.png)](https://travis-ci.org/robinroestenburg/parsed)

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

### Getting started

Say, you have the following configuration file containing your favorite
superhero:

``` ruby
# superhero.json
{ "name": "Spider-Man" }
```

In order to load this data into your program, you need to include the
`Parsed::Parseable` module to the class you want to load the data:

``` ruby
# superhero.rb
class Superhero
  include Parsed::Parseable
  attr_accessor :name
end
```
Sending the `parse`-method with the to the `Superhero` class will 
return a `Superhero` instance:

``` ruby
superhero = Superhero.parse(File.read('superhero.json'))

p superhero.name
# => "Spider-Man"
```

**What if my file contains a field that is not present in the class?**

It will be ignored when parsing the file, as you can see in the following
example:

``` ruby
# superhero.json
{
  "name": "Hulk",
  "power": "Superhuman strength"
}
```

``` ruby
superhero = Superhero.parse(File.read('superhero.json'))

p superhero.power
# => NoMethodError: undefined method `power' for #<Superhero:0x007ff2120f7920>
```

This works both ways, so you can have attributes on your model that are not
present in the data file as well.

### Parsing collections and associations

**What if I have more than one element to parse?**

No problem! You probably have multiple superheroes you like, right? Your
configuration file might look something like this:

``` ruby
# superhero.json
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

``` ruby
# superheroes.json
{
  "name": "The Fantastic Four",
  "superheroes": [
    { "name": "Mister Fantastic" },
    { "name": "Invisible Girl" },
    { "name": "The Humand Torch" },
    { "name": "The Thing" }
  ]
}
```

``` ruby
# team.rb
class Team
  include Parsed::Parseable
  attr_accessor :name, :superheroes
end

# superhero.rb
class Superhero
  include Parsed::Parseable
  attr_accessor :name
end
```

``` ruby
team = Team.parse(File.read("superheroes.json"))

p team.superheroes.size
#=> 4

p team.superheroes.first.name
#=> "Mister Fantastic"
```

### Advanced usage

**You only have been working with text so far. How about parsing dates or
integer values?**

**TODO**

``` ruby
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

``` ruby
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

**There are fields that I don't want to load into my models, is it possible to
skip these?**

Yes, you can use the `skip!` method inside the `parseable` blocks for this.
Let's take our original json file again:

``` ruby
# superhero.json
{
  "name": "Thor",
  "strength": "1200"
}
```

This time, we don't want to load the `strength` field because we are retrieving
that field from the *Superhero Database Webservice by Acme Inc*. Explicitly state
that the field is to be skipped using the `skip!` method:

``` ruby
# superhero.rb
class Superhero
  include Parsed::Parseable

  attr_accessor :name, :strength

  parseable do
    text :name
    skip! :strength
  end

end
```

Now if we look at the `Superhero` instance after parsing the configuration:

``` ruby
superhero = Superhero.parse(File.read('superhero.json'))

p superhero.strength
# => nil
```

## Roadmap

* Provide configuration parameter to be able to log or raise errors when
  detecting a field that we are unable to parse.
* Add logging.
* Replace rspec integration tests by Cucumber features and hook them up to
  Relishapp.
* Write more documentation.
* Implement different parsers: XML, YAML, TOML, etc.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
