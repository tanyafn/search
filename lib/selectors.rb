# frozen_string_literal: true

require_relative 'selectors/base'
require_relative 'selectors/equal_to'
require_relative 'selectors/is_undefined'
require_relative 'selectors/greater_than'
require_relative 'selectors/less_than'

module Selectors
  UnknownOperator = Class.new(StandardError)
  UnknownAttribute = Class.new(StandardError)

  SELECTORS = [
    EqualTo,
    IsUndefined,
    GreaterThan,
    LessThan
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
