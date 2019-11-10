# frozen_string_literal: true

class Collection
  def initialize
    @items = {}
  end

  attr_reader :items

  def <<(items)
    Array.wrap(items).each do |item|
      @items[item[:_id]] = item
    end

    self
  end

  def get(id)
    @items[id]
  end
end
