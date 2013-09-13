require 'spec_helper'

class Superhero
  include Parsed::Parseable
  attr_accessor :name
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
