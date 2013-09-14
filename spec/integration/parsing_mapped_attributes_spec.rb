require 'spec_helper'

module ParsingMappedAttributes

  class Superhero
    include Parsed::Parseable
    attr_accessor :name, :power

    parseable do
      text :name, mapping: 'NAME'
      text :power
    end
  end

end

describe 'parsing mapped attributes' do

  let(:data) do
    <<-EOS
    {
      "NAME": "Thor",
      "power": "Superhuman strength"
    }
    EOS
  end

  subject { ParsingMappedAttributes::Superhero.parse(data) }

  it 'parses the mapped attribute' do
    subject.name.should == 'Thor'
  end

  it 'parses the unmapped field' do
    subject.power.should == 'Superhuman strength'
  end

end
