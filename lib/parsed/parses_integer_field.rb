module Parsed

  class ParsesIntegerField < FieldParser

    def parse_attribute
      Integer(parser.parse_value(parseable_hash, attribute_name))
    rescue ArgumentError
      # do nothing
    end

  end # class ParsesIntegerField

end # module Parser
