# frozen_string_literal: true

require 'json'

class JsonParser
  BadData = Class.new(StandardError)

  def self.parse(json)
    JSON.parse(json, symbolize_names: true)
  rescue StandardError
    raise BadData, 'Unexpected data format'
  end
end
