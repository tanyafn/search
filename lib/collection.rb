# frozen_string_literal: true

class Collection
  def initialize(name)
    @name = name
    @items = {}
    @inverted_indices = Hash.new { |hsh, key| hsh[key] = InvertedIndex.new }
  end

  attr_reader :name, :items, :inverted_indices

  def <<(item)
    @items[item[:_id]] = item
    add_item_to_inverted_indices(item)

    self
  end

  def [](id)
    @items[id].dup
  end

  private

  def add_item_to_inverted_indices(item)
    item_id = item[:_id]

    item.each do |attribute, value|
      index = @inverted_indices[attribute]

      if Array === value
        value.each { |v| index.add(v, item_id) }
        index.add(value.sort, item_id)
      else
        index.add(value, item_id)
      end
    end
  end
end
