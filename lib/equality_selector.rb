# frozen_string_literal: true

class EqualitySelector
  def initialize(attribute:, value:)
    @attribute = attribute.to_sym
    @value = value
  end

  attr_reader :attribute, :value
end
