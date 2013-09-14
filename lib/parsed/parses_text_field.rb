module Parsed

  class ParsesTextField < FieldParser

    def parse_attribute
      parser.parse_value(parseable_hash, attribute_name)
    end

  end

end
