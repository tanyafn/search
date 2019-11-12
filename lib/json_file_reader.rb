# frozen_string_literal: true

class JsonFileReader
  NotFound = Class.new(StandardError)
  BadData = Class.new(StandardError)

  def self.read(filename)
    json = File.read(filename)
    JSON.parse(json, symbolize_names: true)
  rescue JSON::ParserError
    raise BadData, 'Unexpected data format'
  rescue Errno::ENOENT
    raise NotFound, "#{filename} not found"
  end
end
