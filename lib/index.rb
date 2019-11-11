# frozen_string_literal: true

class Index
  def initialize
    @index = {}
  end

  attr_reader :index

  def add(key, value)
    Array.wrap(key).each do |k|
      @index[k] = ((@index[k] || []) << value).uniq
    end
  end

  def lookup(value)
    @index.fetch(value, [])
  end
end
