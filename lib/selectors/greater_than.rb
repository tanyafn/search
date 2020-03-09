# frozen_string_literal: true

module Selectors
  class GreaterThan < Base
    def self.handles?(operator)
      operator == :'>'
    end

    def perform(collection, attribute, value)
      collection
        .inverted_indices[attribute]
        .flat_map { |indexed_value, ids| indexed_value > value ? ids : [] }
        .map { |id| collection[id] }
    end
  end
end
