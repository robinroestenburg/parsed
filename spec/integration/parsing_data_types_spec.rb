require 'spec_helper'

module ParsingWithDataConversion

  class Superhero
    include Parsed::Parseable
    attr_accessor :name, :strength

    parseable do
      text :name
      integer :strength
    end
  end

end

describe 'parsing with datatype conversion' do

  subject { ParsingWithDataConversion::Superhero.parse(data) }

  let(:data) do
    <<-EOS
    {
      "name": "Spider-Man",
      "strength": "20"
    }
    EOS
  end

  it 'parses the text value' do
    subject.name.should eq 'Spider-Man'
  end

  it 'parses the integer value' do
    subject.strength.should eq 20
  end

  describe 'with invalid integer value' do

    let(:data) do
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
