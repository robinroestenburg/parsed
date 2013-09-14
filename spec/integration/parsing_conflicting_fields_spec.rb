require 'spec_helper'

module ParsingConflictingFields

  class Team
    include Parsed::Parseable
    attr_accessor :name, :superheroes

    parseable do
      text :name, mapping: 'NAME'
    end
  end

  class Superhero
    include Parsed::Parseable
    attr_accessor :name
  end

end

describe 'parsing conflicting fields' do

  subject do
    data = <<-EOS
    {
      "NAME": "The Fantastic Four",
      "superheroes": [
        { "name": "Mister Fantastic" },
        { "name": "Invisible Girl" },
        { "name": "The Humand Torch" },
        { "name": "The Thing" }
      ]
    }
    EOS

    ParsingConflictingFields::Team.parse(data)
  end

  it 'returns an object for each element in the collection' do
    subject.superheroes.size.should eq 4
  end

  it 'parses parseable objects inside the collection' do
    subject.superheroes.first.name.should eq 'Mister Fantastic'
    subject.superheroes.last.name.should eq 'The Thing'
  end

end
