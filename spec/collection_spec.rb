# frozen_string_literal: true

require 'spec_helper'

describe Collection do
  let(:item1) { { _id: '111', name: 'Alice', skills: %w[frontend design] } }
  let(:item2) { { _id: '222', name: 'Bob', skills: %w[frontend backend] } }

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

      it { expect(collection.inverted_indices.keys).to eq(%i[_id name skills]) }

      it 'builds inverted index for "skills"' do
        expect(collection.inverted_indices[:skills].index).to eq(
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
      let(:selector) { EqualitySelector.new(attribute: 'skills', value: 'frontend') }

      it 'returns found items' do
        expect(collection.select(selector)).to eq([item1, item2])
      end
    end

    context 'item does not exist' do
      let(:selector) { EqualitySelector.new(attribute: 'skills', value: 'maths') }

      it 'returns an empty array' do
        expect(collection.select(selector)).to eq([])
      end
    end

    context 'selector is not valid' do
      context 'unknown query operator' do
        let(:selector) { double }

        it 'raises an error' do
          expect { collection.select(selector) }.to raise_error(Collection::UnknownOperator)
        end
      end

      context 'unknown attribute' do
        let(:selector) { EqualitySelector.new(attribute: 'none', value: 'maths') }

        it 'raises an error' do
          expect { collection.select(selector) }.to raise_error(Collection::UnknownAttribute, 'Unknown attribute none')
        end
      end
    end
  end
end
