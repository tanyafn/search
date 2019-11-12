# frozen_string_literal: true

class QueryParser
  BadData = Class.new(StandardError)

  REGEX = /^\s*
    select
    \s+(?<collection>\w+)
    \s+where
    \s+(?<attribute>\w+)
    \s+(?<operator>[=\>\<\-\+\w])
    \s+(?<value>.*)/ix.freeze

  def self.parse(query_string)
    match = REGEX.match(query_string)
    raise BadData, 'Unexpected query format' unless match

    Query.new(
      collection: match[:collection],
      attribute: match[:attribute],
      operator: match[:operator],
      value: JSON.parse(match[:value])
    )
  end
end
