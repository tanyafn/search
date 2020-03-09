# frozen_string_literal: true

module Selectors
  UnknownOperator = Class.new(StandardError)
  UnknownAttribute = Class.new(StandardError)

  SELECTORS = [
    EqualTo,
    IsUndefined,
    GreaterThan
  ].freeze

  def self.resolve(query)
    SELECTORS.each do |selector_class|
      if selector_class.handles?(query.operator)
        return selector_class.new(attribute: query.attribute, value: query.value)
      end
    end

    raise UnknownOperator, "Unknown operator #{query.operator}"
  end
end
