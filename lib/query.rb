# frozen_string_literal: true

class Query
  def initialize(collection:, attribute:, operator:, value:)
    @collection = collection
    @attribute = attribute
    @operator = operator
    @value = value
  end

  attr_reader :collection, :attribute, :operator, :value
end
