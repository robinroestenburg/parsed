require 'json'
require 'active_support/inflector'
require_relative 'parses_json'

module Parsed

  module Parseable

    def self.included(base)
      base.instance_variable_set(:@parseable_fields, [])
      base.instance_variable_set(:@collection_class_cache, {})
      base.extend ClassMethods
    end

    module ClassMethods

      attr_accessor :parseable_hash,
                    :parseable_fields,
                    :parser

      def parse(data, parser = ParsesJson)
        @parser = parser
        @parseable_hash = parser.parse(data)

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
          elements = parser.parse_elements(parseable_hash, field)

          elements.map do |element|
            if element.instance_of? Hash
              clazz.parse(element)
            else
              element
            end
          end

        else
          parser.parse_value(parseable_hash, field)
        end
      end

      def determine_collection_class(field)
        if @collection_class_cache.has_key? field
          @collection_class_cache[field]
        else
          @collection_class_cache[field] =
            field.to_s.singularize.camelize.constantize
        end
      rescue NameError => e
        @collection_class_cache[field] = nil
      end
    end
  end
end
