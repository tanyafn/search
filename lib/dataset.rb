# frozen_string_literal: true

class Dataset
  UnknownCollection = Class.new(StandardError)
  InvalidAssociation = Class.new(StandardError)

  def initialize
    @collections = {}
    @associations = []
  end

  def collections
    @collections.values
  end

  def associations
    @associations.clone
  end

  def add_collection(name, items)
    collection = items.inject(Collection.new(name), :<<)
    @collections[name.to_sym] = collection
  end

  def add_association(attrs)
    @associations << Association.new(attrs)
  end

  def search(query)
    raise UnknownCollection, "Unknown collection #{query.collection}" unless @collections.key?(query.collection)

    collection = @collections[query.collection]
    selector = Mapper.resolve(query)
    items = selector.select_from(collection)
    items.map { |item| resolve_associations(item, query.collection) }
  end

  private

  def resolve_associations(item, collection)
    item_with_associations = item.dup

    @associations.each do |assoc|
      if assoc.child_collection == collection
        item_with_associations = resolve_child_association(assoc, item_with_associations)
      end
      if assoc.parent_collection == collection
        item_with_associations = resolve_parent_association(assoc, item_with_associations)
      end
    end

    item_with_associations
  end

  def resolve_child_association(assoc, item)
    unless @collections.key?(assoc.parent_collection)
      raise InvalidAssociation, "Invalid parent collection #{assoc.parent_collection}"
    end

    parent_collection = @collections[assoc.parent_collection]
    parent_id = item[assoc.reference_attribute]
    item.dup.tap { |i| i[assoc.parent_name] = parent_collection.get(parent_id) }
  end

  def resolve_parent_association(assoc, item)
    unless @collections.key?(assoc.child_collection)
      raise InvalidAssociation, "Invalid child collection #{assoc.child_collection}"
    end

    child_collection = @collections[assoc.child_collection]

    s = EqualitySelector.new(attribute: assoc.reference_attribute, value: item[:_id])
    item.dup.tap { |i| i[assoc.children_name] = s.select_from(child_collection) }
  end
end
