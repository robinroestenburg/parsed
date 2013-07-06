require 'json'

module Parsed
  class ParsesJson < Struct.new(:data)

    def self.parse(data)
      JSON.parse(data, { :symbolize_names => true })
    end

    def self.parse_value(data, field)
      data[field.to_sym]
    end

    def self.parse_elements(data, field)
      data[field.to_sym] || []
    end

  end
end
