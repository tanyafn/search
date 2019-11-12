# frozen_string_literal: true

require 'spec_helper'

describe Collection do
  let(:item1) { { _id: '111', name: 'Alice', good_at: %w[frontend design] } }
  let(:item2) { { _id: '222', name: 'Bob', good_at: %w[frontend backend] } }

  subject(:collection) { described_class.new(:users) }

  describe '#<<' do
    it 'adds one item into collection' do
      expect { collection << item1 }.to change { collection.get('111') }.from(nil).to(item1)
    end

    it 'adds multiple items into collection' do
      expect { collection << [item1, item2] }.to change {
        collection.get('111')
      }.from(nil).to(item1).and change {
        collection.get('222')
      }.from(nil).to(item2)
    end

    describe 'builds inverted indices for item fields' do
      before { collection << [item1, item2] }

      it { expect(collection.inverted_indices.keys).to eq(%i[_id name good_at]) }

      it 'builds inverted index for "good_at"' do
        expect(collection.inverted_indices[:good_at].index).to eq(
          'frontend' => %w[111 222],
          'backend' => ['222'],
          'design' => ['111']
        )
      end

      it 'builds inverted index for "name"' do
        expect(collection.inverted_indices[:name].index).to eq(
          'Alice' => ['111'],
          'Bob' => ['222']
        )
      end
    end
  end

  describe '#get' do
    before { collection << [item1] }

    it 'returns item by key' do
      expect(collection.get('111')).to eq(item1)
    end
  end

  describe '#select' do
    before { collection << [item1, item2] }

    context 'items exist' do
      let(:query) { Query.new(collection: 'users', attribute: 'good_at', operator: '=', value: 'frontend') }

      it 'returns found items' do
        expect(collection.select(query)).to eq([item1, item2])
      end
    end

    context 'item does not exist' do
      let(:query) { Query.new(collection: 'users', attribute: 'good_at', operator: '=', value: 'maths') }

      it 'returns an empty array' do
        expect(collection.select(query)).to eq([])
      end
    end

    context 'query is not valid' do
      context 'unknown query operator' do
        let(:query) { Query.new(collection: 'users', attribute: 'good_at', operator: '>', value: 'frontend') }

        it 'raises an error' do
          expect { collection.select(query) }.to raise_error(Collection::UnknownOperator, 'Unknown operator >')
        end
      end

      context 'unknown attribute' do
        let(:query) { Query.new(collection: 'users', attribute: 'foo', operator: '=', value: 'frontend') }

        it 'raises an error' do
          expect { collection.select(query) }.to raise_error(Collection::UnknownAttribute, 'Unknown attribute foo')
        end
      end
    end
  end
end
