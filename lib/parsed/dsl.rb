module Parsed

  module Dsl
    # Registers attributes that are to be parsed. A shorthand for the more
    # verbose `parseable`-block configuration.
    #
    # @example
    #
    #     class Foo
    #       include Parsed::Parseable
    #       attr_accessor :foo, :bar, :baz
    #       parses :foo, :baz
    #     end
    #
    # @param attributes [Array] the fields to be parsed
    def parses(*attributes)
      attributes.each { |attribute| add_attribute(attribute) }
    end

    # Registers attributes that are to be parsed.
    #
    # @example
    #
    #     class Foo
    #       include Parsed::Parseable
    #       attr_accessor :foo, :bar, :baz
    #       parseable do
    #         text :foo
    #         integer :baz
    #       end
    #     end
    #
    # @param block containing configuration of the fields to be parsed
    def parseable(&block)
      dsl = DslDelegator.new(self)
      dsl.instance_eval(&block)
    end

    # Adds an attribute to the list of parseable attributes for this specific
    # instance.
    #
    # @param name [String]
    # @param options [Hash]
    def add_attribute(name, options = {})
      options = options.merge({
        module_name: self.name.deconstantize,
        name: name
      })
      @parseable_attrs << Attribute.new(options)
    end

    # TODO
    #
    #
    class DslDelegator < SimpleDelegator

      #
      #
      # @param name [Symbol] the name of the attribute to add to the list of
      #   parseable attributes
      # @param options [Hash]
      def text(name, options = {})
        add_attribute(name, options)
      end

      #
      #
      # @param name [Symbol] the name of the attribute to add to the list of
      #   parseable attributes
      # @param options [Hash]
      def integer(name, options = {})
        options = options.merge({ type: :integer })
        add_attribute(name, options)
      end

      # Marks the attribute to be skipped when parsing. Attributes are
      # automatically matched by the
      #
      # If you do not mark an attribute as skipped and it is present in the
      # file to be parsed, it will automatically be parse
      #
      # @example
      #
      #     class Foo
      #       include Parsed::Parseable
      #       attr_accessor :foo
      #       parseable do
      #         skip! :foo
      #       end
      #     end
      #
      # @param name [Symbol] the name of the attribute to add to the list of
      #   parseable attributes
      def skip!(name)
        options = { skip: true }
        add_attribute(name, options)
      end

    end # class DslDelegator
  end
end
