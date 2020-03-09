# frozen_string_literal: true

module Selectors
  class Base
    def initialize(attribute:, value:)
      @attribute = attribute.to_sym
      @value = value
    end

    attr_reader :attribute, :value

    def self.handles?(_operator)
      raise 'Not implemented'
    end

    def perform(_collection, _attribute, _value)
      raise 'Not implemented'
    end

    def select_from(collection)
      raise UnknownAttribute, "Unknown attribute #{attribute}" unless collection.inverted_indices.key?(attribute)

      perform(collection, attribute, value)
    end
  end
end
