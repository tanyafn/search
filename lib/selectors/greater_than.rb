# frozen_string_literal: true

module Selectors
  class GreaterThan
    UnknownAttribute = Class.new(StandardError)

    def initialize(attribute:, value:)
      @attribute = attribute.to_sym
      @value = value
    end

    attr_reader :attribute, :value

    def self.handles?(operator)
      operator == :'>'
    end

    def select_from(collection)
      raise UnknownAttribute, "Unknown attribute #{attribute}" unless collection.inverted_indices.key?(attribute)

      collection
        .inverted_indices[attribute]
        .flat_map { |indexed_value, ids| indexed_value > value ? ids : [] }
        .map { |id| collection[id] }
    end
  end
end
