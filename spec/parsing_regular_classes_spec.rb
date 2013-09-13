require 'spec_helper'

module Parsed::BasicUsage

  class Superhero
    include Parsed::Parseable
    attr_accessor :name
  end

  describe 'parsing a single element' do

    it 'copies field values onto the model' do
      configuration = '{ "name": "Batman" }'
      element = Superhero.parse(configuration)
      element.name.should == 'Batman'
    end

    it 'ignores fields not present on the model' do
      configuration = '{ "name": "Batman", "power": "spidersense" }'
      expect {
        Superhero.parse(configuration)
      }.to_not raise_error
    end

    it 'returns an instance of Superhero' do
      configuration = '{ "name": "Batman" }'
      element = Superhero.parse(configuration)
      element.should be_a Superhero
    end

  end

  describe 'parsing a collection of elements' do

    let(:superheroes_configuration) do
      <<-EOS
      [{ "name": "Batman" },
       { "name": "Spiderman" },
       { "name": "Thor" },
       { "name": "The Hulk" },
       { "name": "Iron Man" }]
      EOS
    end

    subject do
      Superhero.parse(superheroes_configuration)
    end

    it 'returns an array' do
      subject.should be_an Array
    end

    it 'parses all elements of the collection' do
      subject.size.should == 5
    end

    it 'creates a Superhero instance for each of the elements' do
      subject.first.should be_a Superhero
    end

    it 'parses the individual elements of the collection' do
      subject.first.name.should == 'Batman'
    end

  end

end

class League
  include Parsed::Parseable
  attr_accessor :name, :country, :teams
  parses :name, :teams
end

class Team
  include Parsed::Parseable
  attr_accessor :name, :city
  parses :name, :city
end

describe League do

  describe '#parse' do

    describe 'parsing fields' do

      let(:premier_league) do
        <<-EOS
        {
          "name": "Premier League",
          "country": "England"
        }
        EOS
      end

      subject do
        League.parse(premier_league)
      end

      it 'parses fields' do
        subject.name.should == 'Premier League'
      end

      it 'skips fields that are not to be parsed' do
        subject.country.should be_nil
      end

    end

    describe 'parsing collections' do

      describe 'with elements' do

        let(:premier_league) do
          <<-EOS
          {
            "name": "Premier League",

            "teams": [
              { "name": "Arsenal", "city": "London" },
              { "name": "Swansea City", "city": "Swansea" }
            ]
          }
          EOS
        end

        subject do
          League.parse(premier_league)
        end

        it 'returns an object for each element in the collection' do
          subject.teams.size.should == 2
        end

        it 'parses parseable objects inside the collection' do
          subject.teams.first.name.should == 'Arsenal'
          subject.teams.first.city.should == 'London'
        end

      end

      describe 'without elements' do

        let(:premier_league) do
          <<-EOS
          {
            "name": "Premier League",
            "teams": []
          }
          EOS
        end

        subject do
          League.parse(premier_league)
        end

        it 'returns an empty collection' do
          subject.teams.should be_empty
        end

      end

      describe 'with primitive elements' do

        let(:premier_league) do
          <<-EOS
          {
            "name": "Premier League",
            "teams": ["Arsenal", "Swansea City"]
          }
          EOS
        end

        subject do
          League.parse(premier_league)
        end

        it 'returns an element for each primitive in the collection' do
          subject.teams.should == ['Arsenal', 'Swansea City']
        end

      end
    end
  end
end
