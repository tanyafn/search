# frozen_string_literal: true

class DataSource
  NotFound = Class.new(StandardError)
  BadData = Class.new(StandardError)

  def initialize(base_path)
    @base_path = base_path
  end

  def [](name)
    json = File.read("#{@base_path}/#{name}.json")
    JSON.parse(json, symbolize_names: true)
  rescue JSON::ParserError
    raise BadData, 'Unexpected data format'
  rescue Errno::ENOENT
    raise NotFound, "Data for #{name} not found in #{@base_path}"
  end
end
