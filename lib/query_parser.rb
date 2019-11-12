# frozen_string_literal: true

require 'json'

class QueryParser
  BadData = Class.new(StandardError)

  REGEX = /^select\s+(?<collection>\w+)\s+where\s+(?<attribute>\w+)\s*(?<operator>[=]+)\s*(?<value>.*)$/i.freeze

  def self.parse(query_string)
    match = REGEX.match(query_string)
    raise BadData, 'Unexpected query format' unless match

    _, collection, attribute, operator, value = match.to_a

    Query.new(
      collection: collection,
      attribute: attribute,
      operator: operator,
      value: JSON.parse(value)
    )
  end
end
