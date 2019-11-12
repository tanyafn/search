# frozen_string_literal: true

gem 'rspec'
gem 'rubocop'

require_relative './lib/search'
require_relative './ui'

begin
  config = JsonFileReader.read('config.json')
  dataset = Dataset.new

  config[:collections].each do |collection|
    dataset.add_collection(collection[:name].to_sym, JsonFileReader.read(collection[:file]))
  end

  config[:associations].each do |association|
    dataset.add_association(association.transform_values(&:to_sym))
  end
rescue StandardError => e
  puts "#{e.message}. The program cannot start."
  exit
end

UI.start(dataset)
