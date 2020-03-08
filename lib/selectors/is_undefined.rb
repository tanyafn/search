# frozen_string_literal: true

module Selectors
  class IsUndefined
    UnknownAttribute = Class.new(StandardError)

    def initialize(attribute:, value: nil)
      @attribute = attribute.to_sym
      @value = value
    end

    attr_reader :attribute, :value

    def self.handles?(operator)
      operator == :is
    end

    def select_from(collection)
      raise UnknownAttribute, "Unknown attribute #{attribute}" unless collection.inverted_indices.key?(attribute)

      inverted_index = collection.inverted_indices[attribute]
      item_ids = collection.items.keys - inverted_index.ids

      item_ids.map { |item_id| collection[item_id] }
    end
  end
end
