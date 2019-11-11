# frozen_string_literal: true

class BelongsToAssociation
  def initialize(collection:, name:, attribute:)
    @collection = collection
    @name = name
    @attribute = attribute
  end

  attr_reader :collection, :name, :attribute
end
