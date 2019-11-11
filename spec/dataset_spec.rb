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
    let(:user1) { { _id: '1', name: 'Alice', org_id: '3' } }
    let(:user2) { { _id: '2', name: 'Bob', org_id: '4' } }
    let(:org1) { { _id: '3', name: 'Foo'} }
    let(:org2) { { _id: '4', name: 'Bar' } }

    let(:users) { Collection.new(:users).tap { |c| c << [user1, user2] } }
    let(:orgs) { Collection.new(:orgs).tap { |c| c << [org1, org2] } }
    let(:assoc) do
      Association.new(
        child: :users,
        child_name: :members,
        reference_attribute: :org_id,
        parent: :orgs,
        parent_name: :org
      )
    end

    before do
      dataset.add_collection(users)
      dataset.add_collection(orgs)
      dataset.add_association(assoc)
    end

    let(:query) do
      Query.new(
        collection: 'users',
        attribute: 'name',
        operator: '=',
        value: 'Alice'
      )
    end

    it 'finds existing items' do
      expect(dataset.search(query).size).to eq(1)
      expect(dataset.search(query).first).to eq(
        _id: '1',
        name: 'Alice',
        org: { _id: '3', name: 'Foo' },
        org_id: '3'
      )
    end
  end
end
