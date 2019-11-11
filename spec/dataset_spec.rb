# frozen_string_literal: true

require 'spec_helper'

describe Dataset do
  subject(:dataset) { described_class.new }

  describe '#add_collection' do
    let(:collection) { double(:collection, name: :a) }

    it 'adds a colelction' do
      expect { dataset.add_collection(collection) }.to change {
        dataset.collections.count
      }.from(0).to(1)
    end
  end

  describe '#add_association' do
    let(:assoc) { double(:assoc) }

    it 'adds an association' do
      expect { dataset.add_association(assoc) }.to change {
        dataset.associations.count
      }.from(0).to(1)
    end
  end

  describe '#search' do
    let(:item1) { { _id: '111', name: 'Alice', good_at: %w[frontend design] } }
    let(:item2) { { _id: '222', name: 'Bob', good_at: %w[frontend backend] } }
    let(:collection) { Collection.new(:users).tap { |c| c << [item1, item2] } }

    before { dataset.add_collection(collection) }

    let(:query) do
      Query.new(collection: 'users',
                attribute: 'name',
                operator: '=',
                value: 'Alice')
    end

    it 'finds existing items' do
      expect(dataset.search(query).size).to eq(1)
    end
  end
end
