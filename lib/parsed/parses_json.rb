require 'json'

module Parsed

  # Parses a piece of JSON data into a hash structure.
  class ParsesJson < Struct.new(:data)

    def self.parse(data)
      return data if data.instance_of? Hash

      JSON.parse(data, { :symbolize_names => true })
    end

    def self.parse_value(data, field)
      data[field.to_sym]
    end

    def self.parse_elements(data, field)
      data[field.to_sym] || []
    end

  end # class ParsesJson

end # module Parsed
