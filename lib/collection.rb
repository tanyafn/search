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

  def <<(item)
    @items[item[:_id]] = item
    add_item_to_inverted_index(item)

    self
  end

  def get(id)
    @items[id].dup
  end

  def select(selector)
    case selector
    when EqualitySelector
      unless @inverted_indices.key?(selector.attribute)
        raise UnknownAttribute, "Unknown attribute #{selector.attribute}"
      end

      ids = @inverted_indices[selector.attribute].lookup(selector.value)
      @items.values_at(*ids).compact.map(&:dup)
    else
      raise UnknownOperator, "Unknown selector #{selector.class.name}"
    end
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
