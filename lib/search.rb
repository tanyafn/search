# frozen_string_literal: true

require 'active_support/core_ext/array' # Array.wrap

Dir["#{__dir__}/**/*.rb"].each { |file| require file }
