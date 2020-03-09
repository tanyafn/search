# frozen_string_literal: true

module Selectors
  class IsUndefined < Base
    def self.handles?(operator)
      operator == :is
    end

    def perform(collection, attribute, _value)
      inverted_index = collection.inverted_indices[attribute]
      item_ids = collection.item_ids - inverted_index.ids
      item_ids.map { |item_id| collection[item_id] }
    end
  end
end
