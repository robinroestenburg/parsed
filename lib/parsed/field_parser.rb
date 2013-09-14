module Parsed

  class FieldParser

    attr_accessor :module_name,
                  :attribute_name,
                  :parser,
                  :parseable_hash,
                  :skip_attribute,
                  :collection_class_cache

    def initialize(args)
      @module_name    = args.fetch(:module_name)
      @attribute_name = args.fetch(:attribute_name)
      @skip_attribute = args.fetch(:skip_attribute)

      @parser         = args.fetch(:parser)
      @parseable_hash = args.fetch(:parseable_hash)

      @collection_class_cache = args.fetch(:cache, {})
    end

    def parse
      return if skip_attribute

      if clazz = determine_collection_class
        parse_collection(clazz)
      else
        parse_attribute
      end
    end

    def parse_collection(clazz)
      elements = parser.parse_elements(parseable_hash, attribute_name)

      elements.map do |element|
        if element.instance_of? Hash

          if clazz.respond_to? :parse
            clazz.parse(element)
          else
            raise "You should include Parsed into '#{clazz}'. Skipping parsing of attribute '#{element.keys.first}'."
          end

        else
          element
        end
      end
    end

    def parse_attribute
      raise NotImplementedError
    end

    def determine_collection_class
      if collection_class_cache.has_key? attribute_name
        collection_class_cache[attribute_name]
      else
        collection_class_cache[attribute_name] =
          "#{module_name}::#{attribute_name.to_s.singularize.camelize}".constantize
      end
    rescue NameError => e
      collection_class_cache[attribute_name] = nil
    end

  end

end
