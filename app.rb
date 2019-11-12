# frozen_string_literal: true

gem 'rspec'
gem 'rubocop'

require 'readline'
require_relative './lib/search'

WELCOME_MESSAGE = %(
  ********************************************************************
          Welcome to Snoopy: almost-elasticsearch app! 🐶
  ********************************************************************

  Snoopy is good at finding things, ask him to find anything for you!
  Here are the commands that Snoopy understands:
)

HELP_MESSAGE = %(
  'h' -- to get help.
  'q' -- to quit.

  To command Snoopy to do anything enter the command and press 'Enter'
)

begin
  path = File.expand_path('./data', Dir.pwd).freeze
  datasource = DataSource.new(path)
  dataset = Dataset.new

  dataset.add_collection(:users, datasource[:users])
  dataset.add_collection(:tickets, datasource[:tickets])
  dataset.add_collection(:organizations, datasource[:organizations])

  dataset.add_association(
    child_collection: :users,
    children_name: :users,
    reference_attribute: :organization_id,
    parent_collection: :organizations,
    parent_name: :organization
  )
  dataset.add_association(
    child_collection: :tickets,
    children_name: :submitted_tickets,
    reference_attribute: :submitter_id,
    parent_collection: :users,
    parent_name: :submitter
  )
  dataset.add_association(
    child_collection: :tickets,
    children_name: :assigned_tickets,
    reference_attribute: :assignee_id,
    parent_collection: :users,
    parent_name: :assignee
  )
  dataset.add_association(
    child_collection: :tickets,
    children_name: :tickets,
    reference_attribute: :organization_id,
    parent_collection: :organizations,
    parent_name: :organization
  )
rescue StandardError => e
  puts "#{e.message}. The program cannot start."
  exit
end

puts WELCOME_MESSAGE
puts HELP_MESSAGE

while (buffer = Readline.readline('> ', true))
  begin
    case buffer
    when 'q'
      puts 'Bye!'
      exit
    when 'h'
      puts HELP_MESSAGE
    else
      query = QueryParser.parse(buffer)
      results = dataset.search(query)
      puts "Found: #{JSON.pretty_generate(results)}!"
    end
  rescue StandardError => e
    puts e.message
  end
end
