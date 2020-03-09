# frozen_string_literal: true

module Selectors
  class EqualTo < Base
    def self.handles?(operator)
      operator == :'='
    end

    def perform(collection, attribute, value)
      normalized_value = value.is_a?(Array) ? value.sort : value

      index = collection.inverted_indices[attribute]
      item_ids = index.lookup(normalized_value)
      item_ids.map { |item_id| collection[item_id] }.compact
    end
  end
end
