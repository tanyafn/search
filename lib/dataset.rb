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

  def add_collection(collection)
    @collections[collection.name.to_sym] = collection
  end

  def add_association(assoc)
    @associations << assoc
  end

  def search(query)
    raise UnknownCollection, "Unknown collection #{query.collection}" unless @collections.key?(query.collection)

    items = @collections[query.collection].find(query)
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

  def resolve_parent_association(assoc, item) # rubocop:disable Metrics/MethodLength
    unless @collections.key?(assoc.child_collection)
      raise InvalidAssociation, "Invalid child collection #{assoc.child_collection}"
    end

    child_collection = @collections[assoc.child_collection]

    q = Query.new(
      collection: assoc.child_collection,
      attribute: assoc.reference_attribute,
      operator: '=',
      value: item[:_id]
    )
    item.dup.tap { |i| i[assoc.children_name] = child_collection.find(q) }
  end
end
