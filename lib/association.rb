# frozen_string_literal: true

class Association
  def initialize(child:, child_name:, reference_attribute:, parent:, parent_name:)
    @child = child
    @child_name = child_name
    @reference_attribute = reference_attribute
    @parent = parent
    @parent_name = parent_name
  end

  attr_reader :child, :child_name, :reference_attribute, :parent, :parent_name
end
