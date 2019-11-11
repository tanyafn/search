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
    let(:org1) { { _id: '3', name: 'Foo' } }
    let(:org2) { { _id: '4', name: 'Bar' } }

    let(:users) { Collection.new(:users).tap { |c| c << [user1, user2] } }
    let(:orgs) { Collection.new(:orgs).tap { |c| c << [org1, org2] } }
    let(:assoc) do
      Association.new(
        child_collection: :users,
        children_name: :members,
        reference_attribute: :org_id,
        parent_collection: :orgs,
        parent_name: :org
      )
    end

    before do
      dataset.add_collection(users)
      dataset.add_collection(orgs)
      dataset.add_association(assoc)
    end

    describe 'searching for items with parents' do
      let(:query) do
        Query.new(
          collection: 'users',
          attribute: 'name',
          operator: '=',
          value: 'Alice'
        )
      end

      it 'finds items with parent associations' do
        expect(dataset.search(query).size).to eq(1)
        expect(dataset.search(query).first).to eq(
          _id: '1',
          name: 'Alice',
          org: { _id: '3', name: 'Foo' },
          org_id: '3'
        )
      end
    end

    describe 'searching for items with children' do
      let(:query) do
        Query.new(
          collection: 'orgs',
          attribute: 'name',
          operator: '=',
          value: 'Foo'
        )
      end

      it 'finds items with child associations' do
        expect(dataset.search(query).size).to eq(1)
        expect(dataset.search(query).first).to eq(
          _id: '3',
          name: 'Foo',
          members: [{ _id: '1', name: 'Alice', org_id: '3' }]
        )
      end
    end

    describe 'searching in unknonw collection' do
      let(:query) do
        Query.new(
          collection: 'none',
          attribute: 'name',
          operator: '=',
          value: 'Foo'
        )
      end

      it 'raises error' do
        expect do
          dataset.search(query)
        end.to raise_error(Dataset::UnknownCollection)
      end
    end

    describe 'search with invalid parent association' do
      let(:invalid_assoc) do
        Association.new(
          child_collection: :users,
          children_name: :members,
          reference_attribute: :org_id,
          parent_collection: :none,
          parent_name: :org
        )
      end

      before { dataset.add_association(invalid_assoc) }

      let(:query) do
        Query.new(
          collection: 'users',
          attribute: 'name',
          operator: '=',
          value: 'Alice'
        )
      end

      it 'raises error' do
        expect do
          dataset.search(query)
        end.to raise_error(Dataset::InvalidAssociation)
      end
    end

    describe 'search with invalid child association' do
      let(:invalid_assoc) do
        Association.new(
          child_collection: :none,
          children_name: :members,
          reference_attribute: :org_id,
          parent_collection: :orgs,
          parent_name: :org
        )
      end

      before { dataset.add_association(invalid_assoc) }

      let(:query) do
        Query.new(
          collection: 'orgs',
          attribute: 'name',
          operator: '=',
          value: 'Foo'
        )
      end

      it 'raises error' do
        expect do
          dataset.search(query)
        end.to raise_error(Dataset::InvalidAssociation)
      end
    end
  end
end
