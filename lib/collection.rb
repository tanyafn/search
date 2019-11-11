# frozen_string_literal: true

class Collection
  UnknownOperator = Class.new(StandardError)
  UnknownAttribute = Class.new(StandardError)

  def initialize(name)
    @name = name
    @items = {}
    @inverted_indices = {}
  end

  attr_reader :name, :items, :inverted_indices

  def <<(items)
    Array.wrap(items).each do |item|
      @items[item[:_id]] = item
      add_item_to_inverted_index(item)
    end

    self
  end

  def get(id)
    @items[id].dup
  end

  def find(query)
    unless query.operator == :'='
      raise UnknownOperator, "Unknown operator #{query.operator}"
    end

    unless @inverted_indices.key?(query.attribute)
      raise UnknownAttribute, "Unknown attribute #{query.attribute}"
    end

    ids = @inverted_indices[query.attribute].lookup(query.value)
    @items.values_at(*ids).compact.map(&:dup)
  end

  private

  def add_item_to_inverted_index(item)
    item.each_key do |attribute|
      index = @inverted_indices.fetch(attribute, Index.new)
      index.add(item[attribute], item[:_id])
      @inverted_indices[attribute] = index
    end
  end
end
