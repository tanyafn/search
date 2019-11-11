# frozen_string_literal: true

class Association
  def initialize(child_collection:, child_name:, reference_attribute:, parent_collection:, parent_name:)
    @child_collection = child_collection
    @child_name = child_name
    @reference_attribute = reference_attribute
    @parent_collection = parent_collection
    @parent_name = parent_name
  end

  attr_reader :child_collection, :child_name, :reference_attribute, :parent_collection, :parent_name
end
