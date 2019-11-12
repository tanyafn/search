# frozen_string_literal: true

require 'json'
require_relative './ui'

Dir["#{__dir__}/lib/**/*.rb"].each { |file| require file }

if $PROGRAM_NAME == __FILE__
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
end
