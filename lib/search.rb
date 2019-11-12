# frozen_string_literal: true

require 'active_support/core_ext/array' # Array.wrap
require 'json'

Dir["#{__dir__}/**/*.rb"].each { |file| require file }
