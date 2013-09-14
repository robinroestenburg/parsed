module Parsed

  class Configuration
    attr_accessor :parser, :skip_root_node

    def initialize
      @parser = ParsesJson
      @skip_root_node = true
    end

    # Provide access to the attributes and methods via the passed block
    #
    # @example
    #   configuration.call do |config|
    #     config.parser = ParsesJson
    #   end
    #
    # @return [self]
    #
    # @api private
    def call(&block)
      block.call(self) if block_given?
      self
    end

  end

end
