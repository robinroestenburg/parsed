require 'json'
require 'active_support/inflector'

module Parsed

  module Parseable

    # Callback invoked whenever the receiver is included in another module or
    # class. This should be used in preference to Module.append_features if your
    # code wants to perform some action when a module is included in another.

    def self.included(base)

      # Sets the instance variable names by symbol to object, thereby
      # frustrating the efforts of the class's author to attempt to provide
      # proper encapsulation. The variable did not have to exist prior to this
      # call. If the instance variable name is passed as a string, that string
      # is converted to a symbol.

      base.instance_variable_set("@parseable_fields",      [])
      base.instance_variable_set("@parseable_collections", [])
      base.instance_variable_set("@parseable_json",        {})

      # Adds to obj the instance methods from each module given as a parameter.

      base.extend ClassMethods
    end

    module ClassMethods

      attr_accessor :parseable_json,
                    :parseable_fields,
                    :parseable_collections

      def parse(data)
        @parseable_json = JSON.parse(data, { :symbolize_names => true })

        instance = new
        parse_instance(instance)
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

      def parses_collection(type)
        parseable_collections << type
      end

      private

      def parse_instance(instance)
        parse_fields(instance)
        parse_collections(instance)
      end

      def parse_fields(instance)
        parseable_fields.each do |field|
          value = parseable_json[field.to_sym]
          instance.send("#{field}=".to_sym, value)
        end
      end

      def parse_collections(instance)
        parseable_collections.each do |collection|

          clazz = Kernel.const_get(collection.to_s.singularize.camelize)
          elements = parseable_json[collection] || []

          parsed_elements = elements.map do |element|
            clazz.parse(element.to_json)
          end

         instance.send("#{collection}=".to_sym, parsed_elements)
        end
      end

    end

  end

end
