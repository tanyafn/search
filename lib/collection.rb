# frozen_string_literal: true

class Collection
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
    @items[id]
  end

  def find(query)
    raise "Unknown operator #{query.operator}" unless query.operator == :'='
    raise "Unknown attribute #{query.attribute}" unless @inverted_indices.key?(query.attribute)

    ids = @inverted_indices[query.attribute].lookup(query.value)
    @items.values_at(*ids)
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
