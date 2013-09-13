require 'json'
require 'active_support/inflector'
require_relative 'parses_json'

module Parsed

  module Parseable

    def self.included(base)
      base.instance_variable_set(:@parseable_attrs, {})
      base.instance_variable_set(:@collection_class_cache, {})
      base.extend ClassMethods
    end

    module ClassMethods

      attr_accessor :parseable_hash,
                    :parseable_attrs,
                    :parser

      def parse(data, parser = ParsesJson)
        @parser = parser
        @parseable_hash = parser.parse(data)

        if @parseable_hash.is_a? Array

          elements = @parseable_hash
          elements.map do |element|
            @parseable_hash = element
            instance = new
            parse_fields(instance)
            instance
          end
        else
          instance = new
          parse_fields(instance)
          instance
        end
      end


      def text(attribute)
        parseable_attrs.update({ attribute => :text })
      end

      def integer(attribute)
        parseable_attrs.update({ attribute => :integer })
      end

      def parseable(&block)
        instance_eval(&block)
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
      #     parses :foo, :bar, :baz
      #   end
      #
      def parses(*attributes)
        attributes.each do |attribute|
          text attribute
        end
      end

      private

      def parse_fields(instance)
        parseable_hash.keys.each do |field|
          if parseable_attrs.has_key?(field)

            if parseable_attrs[field] == :integer
              parse_int(instance, field)
            else # :text, default behaviour
              value = parse_field(field)
              instance.send("#{field}=".to_sym, value)
            end

          elsif instance.respond_to?(field.to_sym)
            value = parse_field(field)
            instance.send("#{field}=".to_sym, value)
          end
        end
      end

      def parse_int(instance, field)
        value = Integer(parse_field(field))
        instance.send("#{field}=".to_sym, value)
      rescue ArgumentError
        # do nothing
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
