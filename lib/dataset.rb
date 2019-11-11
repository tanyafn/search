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
    @collections[query.collection].find(query)
  end
end
