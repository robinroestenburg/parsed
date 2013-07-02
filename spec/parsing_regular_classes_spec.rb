require 'spec_helper'

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
          subject.teams.size == 2
        end

        it 'parses parseable objects inside the collection' do
          subject.teams.first.name == 'Arsenal'
          subject.teams.first.city == 'Swansea City'
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
    end
  end
end
