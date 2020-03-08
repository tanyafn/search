# frozen_string_literal: true

require 'spec_helper'

describe Dataset do
  subject(:dataset) { described_class.new }

  describe '#collection' do
    it 'adds a collection to a dataset' do
      expect { dataset.collection(:a, [{ a: :b }]) }.to change {
        dataset.collections.count
      }.from(0).to(1)
    end
  end

  describe '#add_association' do
    let(:attrs) do
      {
        child_collection: :users,
        children_name: :members,
        reference_attribute: :org_id,
        parent_collection: :orgs,
        parent_name: :org
      }
    end

    it 'adds an association' do
      expect { dataset.add_association(attrs) }.to change {
        dataset.associations.count
      }.from(0).to(1)
    end
  end

  describe '#search' do
    let!(:dataset) do
      described_class.new do
        collection :users, [
          { _id: '1', name: 'Alice', org_id: '3' },
          { _id: '2', name: 'Bob', org_id: '4' }
        ]
        collection :orgs, [
          { _id: '3', name: 'Foo' },
          { _id: '4', name: 'Bar' }
        ]
      end
    end

    let(:attrs) do
      {
        child_collection: :users,
        children_name: :members,
        reference_attribute: :org_id,
        parent_collection: :orgs,
        parent_name: :org
      }
    end

    before do
      dataset.add_association(attrs)
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
      let(:invalid_attrs) do
        {
          child_collection: :users,
          children_name: :members,
          reference_attribute: :org_id,
          parent_collection: :none,
          parent_name: :org
        }
      end

      before { dataset.add_association(invalid_attrs) }

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
      let(:invalid_attrs) do
        {
          child_collection: :none,
          children_name: :members,
          reference_attribute: :org_id,
          parent_collection: :orgs,
          parent_name: :org
        }
      end

      before { dataset.add_association(invalid_attrs) }

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
