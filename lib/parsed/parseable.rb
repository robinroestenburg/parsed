require 'json'

module Parsed

  module Parseable

    def self.included(base)
      base.instance_variable_set("@fields", [])
      base.instance_variable_set("@collections", [])
      base.instance_variable_set("@json", {})

      base.extend ClassMethods
    end

    module ClassMethods

      def parse(json)
        @json = JSON.parse(json, { :symbolize_names => true })

        instance = new
        parse_instance(instance)
        instance
      end

      def parses(type)
        @fields << type
      end

      def parses_collection(type)
        @collections << type
      end

      private

      def parse_instance(instance)
        parse_fields(instance)
        parse_collections(instance)
      end

      def parse_fields(instance)
        @fields.each do |field|
          value = @json[field.to_sym]
          instance.send("#{field}=".to_sym, value)
        end
      end

      def parse_collections(instance)
        @collections.each do |collection|

          clazz = Kernel.const_get(collection.to_s.singularize.camelize)
          elements = @json[collection] || []

          parsed_elements = elements.map do |element|
            clazz.parse(element.to_json)
          end

          instance.send("#{collection}=".to_sym, parsed_elements)
        end
      end

    end

  end

end
