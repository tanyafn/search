# frozen_string_literal: true

class Association
  def initialize(child_collection:, children_name:, reference_attribute:, parent_collection:, parent_name:)
    @child_collection = child_collection.to_sym
    @children_name = children_name.to_sym
    @reference_attribute = reference_attribute.to_sym
    @parent_collection = parent_collection.to_sym
    @parent_name = parent_name.to_sym
  end

  attr_reader :child_collection,
              :children_name,
              :reference_attribute,
              :parent_collection,
              :parent_name
end
