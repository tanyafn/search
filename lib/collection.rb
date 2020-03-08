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
    add_item_to_inverted_index(item)

    self
  end

  def [](id)
    @items[id].dup
  end

  private

  def add_item_to_inverted_index(item)
    item.each_key do |attribute|
      index = @inverted_indices[attribute]
      value = item[attribute]
      if value.is_a?(Array)
        value.each { |v| index.add(v, item[:_id]) }
        value = value.sort
      end
      index.add(value, item[:_id])
    end
  end
end
