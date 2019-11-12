# frozen_string_literal: true
require 'set'

class Index
  def initialize
    @index = Hash.new { |hash, value| hash[value] = Set.new }
  end

  def add(value, id)
    @index[value] << id
  end

  def lookup(value)
    @index[value].to_a
  end
end
