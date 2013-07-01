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

Say, you have a JSON file containing football divisions and their teams:

``` json
{
  name: "Premier League",
  country: "England",

  teams: [
    {
      name: "Arsenal",
      city: "London"
    },
    {
      name: "Swansea City",
      city: "Swansea"
    }
  ]
}
```

You would like to use this data in your Ruby program to create a game.

In order to do this you have two basic models: `League` and `Team`. You declare
what attributes and collections need to be parsed on those models:

``` ruby
# file: league.rb
class League
  include Parsed::Parseable

  attr_accessor :name, :country, :teams

  parses :name
  parses :country
  parses_collection :teams

end

# file: team.rb
class Team
  include Parsed::Parseable

  attr_accessor :name, :city

  parses :name
  parses :city

end
```

Finally, you parse the JSON file as follows:

``` ruby
require 'rubygems'
require 'parsed'

league = League.parse(File.read('premier_league.json'))

p league.name  # => 'Premier League'
p league.teams # =>

arsenal = league.teams.first

p arsenal.name # => 'Arsenal'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
