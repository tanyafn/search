# frozen_string_literal: true

class Collection
  def initialize(name)
    @name = name
    @items = {}
    @inverted_indices = {}
  end

  attr_reader :name, :items, :inverted_indices

  def <<(item)
    @items[item[:_id]] = item
    add_item_to_inverted_index(item)

    self
  end

  def get(id)
    @items[id].dup
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
