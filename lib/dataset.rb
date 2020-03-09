# frozen_string_literal: true

class Dataset
  UnknownCollection = Class.new(StandardError)
  InvalidAssociation = Class.new(StandardError)

  def initialize(&block)
    @collections = {}
    @associations = []

    instance_eval(&block) if block_given?
  end

  def collection(name, items)
    collection = Collection.new(name.to_sym)
    @collections[collection.name] = items.inject(collection, :<<)
  end

  def collections
    @collections.values
  end

  def associations
    @associations.clone
  end

  def associate(parent_collection, with:, as: nil, via:, parent_as:)
    @associations << Association.new(
      parent_collection: parent_collection,
      child_collection: with,
      children_name: as || with,
      reference_attribute: via,
      parent_name: parent_as
    )
  end

  def search(query)
    raise UnknownCollection, "Unknown collection #{query.collection}" unless @collections.key?(query.collection)

    collection = @collections[query.collection]
    selector = Selectors::Mapper.resolve(query)
    items = selector.select_from(collection)
    items.map { |item| resolve_associations(item, query.collection) }
  end

  private

  def resolve_associations(item, collection)
    @associations.inject(item.dup) do |item_with_associations, assoc|
      if assoc.child_collection == collection
        merge_with_parent(assoc, item_with_associations)
      elsif assoc.parent_collection == collection
        merge_with_children(assoc, item_with_associations)
      else
        item_with_associations
      end
    end
  end

  def merge_with_parent(assoc, item)
    unless @collections.key?(assoc.parent_collection)
      raise InvalidAssociation, "Invalid parent collection #{assoc.parent_collection}"
    end

    parent_collection = @collections[assoc.parent_collection]
    parent_item_id = item[assoc.reference_attribute]
    item.dup.tap { |i| i[assoc.parent_name] = parent_collection[parent_item_id] }
  end

  def merge_with_children(assoc, item)
    unless @collections.key?(assoc.child_collection)
      raise InvalidAssociation, "Invalid child collection #{assoc.child_collection}"
    end

    child_collection = @collections[assoc.child_collection]

    selector = Selectors::EqualTo.new(attribute: assoc.reference_attribute, value: item[:_id])
    item.dup.tap { |i| i[assoc.children_name] = selector.select_from(child_collection) }
  end
end
