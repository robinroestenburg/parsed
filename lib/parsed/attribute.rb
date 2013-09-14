module Parsed

  class Attribute

    attr_accessor :name,
                  :type,
                  :module_name,
                  :mapping,
                  :skip

    def initialize(args)
      @module_name = args.fetch(:module_name)
      @name        = args.fetch(:name)
      @type        = args.fetch(:type, :text)
      @mapping     = args.fetch(:mapping, @name)
      @skip        = args.fetch(:skip, false)
    end

    def parse(parser, element_hash)
      options = {
        attribute_name: mapping.to_sym,
        skip_attribute: skip,
        parser:         parser,
        parseable_hash: element_hash,
        module_name:    module_name
      }

      if type == :integer
        ParsesIntegerField.new(options).parse
      else
        ParsesTextField.new(options).parse
      end
    end

  end # class Attribute

end # module Parsed
