require 'spec_helper'

module Parsed::WithMapping

  class Superhero
    include Parsed::Parseable
    attr_accessor :name, :power, :strength

    parseable do
      text :name, mapping: 'NAME'
      text :power
      integer :strength
    end

  end

  describe 'parsing mapped fields' do

    let(:configuration) do
      <<-EOS
      {
        "NAME": "Thor",
        "power": "Superhuman strength",
        "strength": "1200"
      }
      EOS
    end

    subject { Superhero.parse(configuration) }

    it 'parses the name correctly' do
      subject.name.should == 'Thor'
    end

    it 'parses the unmapped field correctly' do
      subject.power.should == 'Superhuman strength'
    end

  end

end
