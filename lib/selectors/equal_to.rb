# frozen_string_literal: true

module Selectors
  class EqualTo
    UnknownAttribute = Class.new(StandardError)

    def initialize(attribute:, value:)
      @attribute = attribute.to_sym
      @value = value.is_a?(Array) ? value.sort : value
    end

    attr_reader :attribute, :value

    def self.handles?(operator)
      operator == :'='
    end

    def select_from(collection)
      raise UnknownAttribute, "Unknown attribute #{attribute}" unless collection.inverted_indices.key?(attribute)

      index = collection.inverted_indices[attribute]
      item_ids = index.lookup(value)
      item_ids.map { |item_id| collection[item_id] }.compact
    end
  end
end
