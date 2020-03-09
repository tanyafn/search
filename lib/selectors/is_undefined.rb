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
      unless collection.inverted_indices.key?(attribute)
        raise UnknownAttribute, "Unknown attribute #{attribute}"
      end

      inverted_index = collection.inverted_indices[attribute]
      item_ids = collection.item_ids - inverted_index.ids
      item_ids.map { |item_id| collection[item_id] }
    end
  end
end
