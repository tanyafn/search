# frozen_string_literal: true

class Dataset
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
    items = @collections[query.collection].find(query)

    @associations.each do |assoc|
      if assoc.child_collection == query.collection
        parent_collection = @collections[assoc.parent_collection]

        items.each do |item|
          parent_id = item[assoc.reference_attribute]
          item[assoc.parent_name] = parent_collection.get(parent_id)
        end
      end
    end

    items
  end
end
