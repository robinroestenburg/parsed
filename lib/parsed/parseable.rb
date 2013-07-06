require 'json'
require 'active_support/inflector'
require_relative 'parses_json'

module Parsed

  module Parseable

    # Callback invoked whenever the receiver is included in another module or
    # class. This should be used in preference to Module.append_features if your
    # code wants to perform some action when a module is included in another.

    def self.included(base)

      # Sets the instance variable names by symbol to object. The variable did
      # not have to exist prior to this call. If the instance variable name is
      # passed as a string, that string is converted to a symbol.

      base.instance_variable_set(:@parseable_fields,      [])
      base.instance_variable_set(:@parseable_collections, [])

      base.extend ClassMethods
    end

    module ClassMethods

      attr_accessor :parseable_json,
                    :parseable_fields,
                    :parseable_collections,
                    :parser

      def parse(data, parser = ParsesJson)
        @parser = parser
        @parseable_json = parser.parse(data)

        instance = new
        parse_fields(instance)
        instance
      end

      # Public: Registers attributes that are to be parsed.
      #
      # attributes - The fields to be parsed
      #
      # Examples
      #
      #   class Foo
      #     include Parsed::Parseable
      #     attr_accessor :foo, :bar, :baz
      #     parsed :foo, :bar, :baz
      #   end
      #
      def parses(*attributes)
        attributes.each do |attributes|
          parseable_fields << attributes
        end
      end

      private

      def parse_fields(instance)
        parseable_fields.each do |field|
          value = parse_field(field)
          instance.send("#{field}=".to_sym, value)
        end
      end

      def parse_field(field)
        clazz = determine_collection_class(field)
        if clazz
          elements = parser.parse_elements(parseable_json, field)

          elements.map do |element|
            if element.instance_of? Hash
              clazz.parse(element.to_json)
            else
              element
            end
          end
        else
          parser.parse_value(parseable_json, field)
        end
      end

      def determine_collection_class(field)
        field.to_s.singularize.camelize.constantize
      rescue NameError => e
        nil
      end
    end
  end
end
