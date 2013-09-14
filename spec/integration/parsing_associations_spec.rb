require 'spec_helper'

module ParsingAssociations

  class Team
    include Parsed::Parseable
    attr_accessor :name, :superheroes

    parseable do
      text :name
    end
  end

  class Superhero
    include Parsed::Parseable
    attr_accessor :name
  end

end

describe 'parsing associations' do

  let(:data) { '' }

  subject do
    ParsingAssociations::Team.parse(data)
  end

  describe 'with elements' do

    let(:data) do
      <<-EOS
      {
        "name": "The Fantastic Four",
        "superheroes": [
          { "name": "Mister Fantastic" },
          { "name": "Invisible Girl" },
          { "name": "The Humand Torch" },
          { "name": "The Thing" }
        ]
      }
      EOS
    end

    it 'returns an object for each element in the collection' do
      subject.superheroes.size.should == 4
    end

    it 'parses parseable objects inside the collection' do
      subject.superheroes.first.name.should == 'Mister Fantastic'
      subject.superheroes.last.name.should == 'The Thing'
    end

  end

  describe 'without elements' do

    let(:data) do
      <<-EOS
      {
        "name": "The Fantastic Zero",
        "superheroes": []
      }
      EOS
    end

    it 'returns an empty collection' do
      subject.superheroes.should be_empty
    end

  end

  describe 'with primitive elements' do

    let(:data) do
      <<-EOS
      {
        "name": "The Fantastic Zero",
        "superheroes": [
          "Mister Fantastic",
          "Invisible Girl",
          "The Humand Torch",
          "The Thing"
        ]
      }
      EOS
    end

    it 'returns an element for each primitive in the collection' do
      subject.superheroes.should == [
        'Mister Fantastic',
        'Invisible Girl',
        'The Humand Torch',
        'The Thing'
      ]
    end

  end

end
