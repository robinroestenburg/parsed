require 'spec_helper'

module Parsed

  describe FieldParser do

    let(:mock_parser) { double }

    it 'should delegate parsing of attributes to subclasses of FieldParser' do
      args = {
        module_name: 'Foo',
        attribute_name: 'foo',
        skip_attribute: false,
        parser: mock_parser,
        parseable_hash: {}
      }

      expect {
        FieldParser.new(args).parse
      }.to raise_error NotImplementedError
    end

    it 'should return nil when the attribute is flagged to be skipped' do
      args = {
        skip_attribute: true,
        module_name:    double,
        attribute_name: double,
        parser:         double,
        parseable_hash: double,
      }

      FieldParser.new(args).parse.should be_nil
    end


    describe 'parsing collections' do

      context 'with primitives' do

        let(:mock_parser) { double(parse_elements: [1, 2, 3]) }
        let(:mock_class)  { double }
        let(:mock_hash)   { double }
        let(:args) do
          {
            module_name: 'Foo',
            attribute_name: 'foo',
            skip_attribute: false,
            parser: mock_parser,
            parseable_hash: mock_hash,
            cache: { 'foo' => mock_class }
          }
        end

        it 'should retrieve the attribute from the hash using the parser' do
          mock_parser.should_receive(:parse_elements).with(mock_hash, 'foo')
          FieldParser.new(args).parse
        end

        it 'should return the elements in the collection' do
          FieldParser.new(args).parse.should eq [1, 2, 3]
        end

      end

      context 'with objects' do

        let(:mock_parser) do
          double(parse_elements: [{ 'bar' => 42 }, { 'baz' => 1337 }])
        end

        let(:mock_class)  { double }
        let(:mock_hash)   { double }

        let(:args) do
          {
            module_name: 'Foo',
            attribute_name: 'foo',
            skip_attribute: false,
            parser: mock_parser,
            parseable_hash: mock_hash,
            cache: { 'foo' => mock_class }
          }
        end

        it 'should parse the values of the objects in the collection using the parser that is present on the class' do
          mock_class.stub(:respond_to?) { true }
          mock_class.stub(:parse) { |element| element[element.keys.first] }
          FieldParser.new(args).parse.should eq [42, 1337]
        end

        it 'should raise an error when no parser is present on the class' do
          mock_class.stub(:respond_to?) { false }

          expect {
            FieldParser.new(args).parse
          }.to raise_error
        end

      end
    end
  end
end
