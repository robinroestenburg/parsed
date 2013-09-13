require 'spec_helper'

module Parsed::DataTypeConversion

  class Superhero
    include Parsed::Parseable
    attr_accessor :name, :strength

    parseable do
      text    :name
      integer :strength
    end

  end

  describe 'parsing with datatype conversion' do

    let(:superheroes_configuration) do
      <<-EOS
      {
        "name": "Spider-Man",
        "strength": "20"
      }
      EOS
    end

    subject do
      Superhero.parse(superheroes_configuration)
    end

    it 'parses the text value' do
      subject.name.should == 'Spider-Man'
    end

    it 'parses the integer value' do
      subject.strength.should == 20
    end

    describe 'with invalid integer value' do

      let(:superheroes_configuration) do
        <<-EOS
        {
          "name": "Spider-Man",
          "strength": "20.5"
        }
        EOS
      end

      it 'ignores the invalid integer field' do
        subject.name.should == 'Spider-Man'
        subject.strength.should be_nil
      end

    end

  end

end
