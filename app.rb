# frozen_string_literal: true

require 'json'
require_relative 'ui'
require_relative 'lib/query'
require_relative 'lib/query_parser'
require_relative 'lib/json_file_reader'
require_relative 'lib/inverted_index'
require_relative 'lib/dataset'
require_relative 'lib/collection'
require_relative 'lib/association'
require_relative 'lib/selectors'

if $PROGRAM_NAME == __FILE__
  begin
    dataset = Dataset.new do
      collection :users,         JsonFileReader.read('./data/users.json')
      collection :tickets,       JsonFileReader.read('./data/tickets.json')
      collection :organizations, JsonFileReader.read('./data/organizations.json')

      associate :organizations, with: :users,   via: :organization_id, parent_as: :organization
      associate :organizations, with: :tickets, via: :organization_id, parent_as: :organization

      associate :users, with: :tickets, as: :submitted_tickets, via: :submitter_id, parent_as: :submitter
      associate :users, with: :tickets, as: :assigned_tickets,  via: :assignee_id,  parent_as: :assignee
    end
  rescue StandardError => e
    puts "#{e.message}. The program cannot start."
    exit
  end

  UI.start(dataset)
end
