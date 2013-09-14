require 'json'
require 'active_support/inflector'

module Parsed

  # Provides access to the global Parsed configuration
  #
  # @example
  #   Parsed.config do |config|
  #     config.parser = ParsesJson
  #   end
  #
  # @return [Configuration]
  #
  # @api public
  def self.config(&block)
    configuration.call(&block)
  end

  module Parseable

    def self.included(base)
      base.extend Dsl
      base.extend ClassMethods
      base.instance_variable_set(:@configuration, Parsed.configuration)

      base.class_eval do
        # Class level instance variable, used for storing the attributes that
        # are added using the `parseable` or `parsed` declarations.
        @parseable_attrs = []

        def self.parseable_attrs
          @parseable_attrs
        end

      end
    end
  end

  private

  # Global configuration instance
  #
  # @return [Configuration]
  #
  # @api private
  def self.configuration
    @configuration ||= Configuration.new
  end


end

require 'parsed/version'
require 'parsed/dsl'
require 'parsed/configuration'
require 'parsed/class_methods'
require 'parsed/attribute'
require 'parsed/field_parser'
require 'parsed/parses_integer_field'
require 'parsed/parses_text_field'
require 'parsed/parses_json'
