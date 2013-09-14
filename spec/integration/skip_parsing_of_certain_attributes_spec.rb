require 'spec_helper'

module ParsingSkippedFields

  class Superhero
    include Parsed::Parseable
    attr_accessor :name, :strength

    parseable do
      text :name
      skip! :strength
    end
  end

end

describe 'skip parsing of certain attributes' do

  subject do
    ParsingSkippedFields::Superhero.parse('{ "name": "Thor", "strength": "1200" }')
  end

  its(:name)     { should eq 'Thor' }
  its(:strength) { should be_nil }

end
