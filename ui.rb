# frozen_string_literal: true

require 'readline'

class UI
  WELCOME_MESSAGE = %(
    ********************************************************************
            Welcome to Snoopy App: almost-elasticsearch app! 🐶
    ********************************************************************

    Snoopy is good at finding things, ask him to find anything for you!
    Here are the commands that Snoopy understands:
  )

  HELP_MESSAGE = %(
    'h', 'help' or '?' -- to get help.
    'exit' or 'q' -- to quit.
    'select <entries name> where <condition>' -- to find <entries> by some <condition>
    Here are some commands examples:

    select users where name = "Cross Barlow"
    select organizations where shared_tickets = true
    select tickets where type = "incident"

    To command Snoopy to do anything, please enter the command and press 'Enter'
  )

  def self.start(dataset)
    puts WELCOME_MESSAGE
    puts HELP_MESSAGE

    while (line = Readline.readline('> ', true))
      begin
        case line
        when 'exit', 'q'
          puts 'Bye!'
          exit
        when 'h', 'help', '?'
          puts HELP_MESSAGE
        else
          query = QueryParser.parse(line)
          results = dataset.search(query)
          puts "Found: #{JSON.pretty_generate(results)}!"
        end
      rescue StandardError => e
        puts e.message
      end
    end
  end
end
