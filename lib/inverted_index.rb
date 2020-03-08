# frozen_string_literal: true

require 'set'

class InvertedIndex
  def initialize
    @index = Hash.new { |hash, value| hash[value] = Set.new }
  end

  def add(value, id)
    @index[value] << id
  end

  def lookup(value)
    @index[value].to_a
  end

  def ids
    @index.values.flat_map(&:to_a)
  end
end