# frozen_string_literal: true

class Query
  def initialize(collection:, attribute:, operator:, value:)
    @collection = collection.to_sym
    @attribute = attribute.to_sym
    @operator = operator.to_sym
    @value = value
  end

  attr_reader :collection, :attribute, :operator, :value
end
