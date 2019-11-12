# frozen_string_literal: true

class EqualitySelector
  UnknownAttribute = Class.new(StandardError)

  def initialize(attribute:, value:)
    @attribute = attribute.to_sym
    @value = value
  end

  attr_reader :attribute, :value

  def self.handles?(operator)
    operator == :'='
  end

  def select_from(collection)
    index = collection.inverted_indices[attribute]
    raise UnknownAttribute, "Unknown attribute #{attribute}" unless index

    ids = index.lookup(value)
    ids.map { |id| collection.get(id) }.compact
  end
end
