# frozen_string_literal: true

class DataSource
  BadData = Class.new(StandardError)

  def self.[](name)
    json = File.read(Dir.glob("../data/#{name}.json"))
    JSON.parse(json, symbolize_names: true)
  rescue StandardError
    raise BadData, 'Unexpected data format'
  end
end
