require 'spec_helper'

module ParsingData

  class Superhero
    include Parsed::Parseable
    attr_accessor :name
  end

end

describe 'parsing data' do

  subject { ParsingData::Superhero.parse(data) }

  context 'with a single element' do

    let(:data) do
      <<-EOS
      {
        "name": "Batman",
        "power": "spidersense"
      }
      EOS
    end

    it 'copies field values onto the model' do
      expect(subject.name).to eq 'Batman'
    end

    it 'ignores fields not present on the model' do
      expect {
        subject
      }.to_not raise_error
    end

    it 'returns an instance' do
      expect(subject).to be_a ParsingData::Superhero
    end

  end

  context 'with a collection of elements' do

    let(:data) do
      <<-EOS
      [{ "name": "Batman" },
       { "name": "Spiderman" },
       { "name": "Thor" },
       { "name": "The Hulk" },
       { "name": "Iron Man" }]
      EOS
    end

    it 'returns an array' do
      subject.should be_an Array
    end

    it 'parses all elements of the collection' do
      subject.size.should eq 5
    end

    it 'creates an instance for each of the elements' do
      subject.first.should be_a ParsingData::Superhero
    end

    it 'parses the individual elements of the collection' do
      subject.first.name.should eq 'Batman'
    end

  end

end
