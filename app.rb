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
  's' -- to search.
  'q' -- to quit.

  To command Snoopy to do anything enter the command and press 'Enter'
)

users_json = File.read('./data/users.json')
users = Collection.new << JsonParser.parse(users_json)

puts WELCOME_MESSAGE
puts HELP_MESSAGE

while (buffer = Readline.readline('> ', true))
  begin
    case buffer
    when 'q'
      puts 'Bow-wow! Bye!'
      exit
    when 'h'
      puts HELP_MESSAGE
    else
      query = QueryParser.parse(buffer)
      found_users = users.find(query)
      puts "Found: #{JSON.pretty_generate(found_users)}!"
    end
  rescue StandardError => e
    puts e.message
  end
end
