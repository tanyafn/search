# frozen_string_literal: true

class Index
  def initialize
    @index = {}
  end

  attr_reader :index

  def add(value, id)
    Array.wrap(value).each do |v|
      @index[v] = ((@index[v] || []) << id).uniq
    end
  end

  def lookup(value)
    @index.fetch(value, [])
  end
end
