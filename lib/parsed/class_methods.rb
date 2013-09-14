module Parsed

  module ClassMethods

    attr_accessor :configuration

    # Parses given content of a data file using the supplied parser and loads
    # the data into one or an array of instance of the class into which the
    # `Parsed::Parseable` module is included.
    #
    # @param data
    def parse(data, options = {})
      parsed_data = parser.parse(data)

      if options[:skip_root]
        parsed_data = parsed_data[self.name.pluralize.downcase.to_sym]
      end


      if parsed_data.is_a? Array
        parse_elements(parsed_data)
      else
        parse_element(parsed_data)
      end
    end

    private

    def parser
      configuration.parser
    end

    def parse_elements(elements)
      elements.map { |element| parse_element(element) }
    end

    def parse_element(element)
      instance = self.new
      parse_fields(instance, element)
      instance
    end

    def parse_fields(instance, element_hash)
      element_hash.keys.each do |field|

        # Unconfigured fields... support or not?
        if instance.respond_to? field
          module_name = instance.class.name.deconstantize
          parseable_attrs << Attribute.new({
            module_name: module_name,
            name: field
          })
        end

        if attribute = find_parseable_attr(parseable_attrs, field)
          value = attribute.parse(parser, element_hash)
          instance.send("#{attribute.name}=".to_sym, value)
        end

      end
    end

    def find_parseable_attr(parseable_attrs, field)
      parseable_attrs.detect { |attribute| attribute.mapping.to_sym == field }
    end
  end
end
