# frozen_string_literal: true

class Dataset
  UnknownCollection = Class.new(StandardError)

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

  def search(query) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    items = select_items(query)

    @associations.each do |assoc|
      if assoc.child_collection == query.collection
        parent_collection = @collections[assoc.parent_collection]

        items.each do |item|
          parent_id = item[assoc.reference_attribute]
          item[assoc.parent_name] = parent_collection.get(parent_id)
        end
      end

      if assoc.parent_collection == query.collection
        child_collection = @collections[assoc.child_collection]

        items.each do |item|
          q = Query.new(
            collection: assoc.child_collection,
            attribute: assoc.reference_attribute,
            operator: '=',
            value: item[:_id]
          )
          item[assoc.children_name] = child_collection.find(q)
        end
      end
    end

    items
  end

  private

  def select_items(query)
    unless @collections.key?(query.collection)
      raise UnknownCollection, "Unknown collection #{query.collection}"
    end

    @collections[query.collection].find(query)
  end
end
