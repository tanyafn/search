# frozen_string_literal: true

require 'spec_helper'

describe Collection do
  let(:item1) { { _id: '111', name: 'Alice', skills: %w[frontend design] } }
  let(:item2) { { _id: '222', name: 'Bob', skills: %w[frontend backend] } }

  subject(:collection) { described_class.new(:users) }

  describe '#<<' do
    it 'adds an item into collection' do
      expect { collection << item1 }.to change { collection['111'] }.from(nil).to(item1)
    end

    describe 'builds inverted indices for item fields' do
      before do
        collection << item1
        collection << item2
      end

      it { expect(collection.inverted_indices.keys).to eq(%i[_id name skills]) }
    end
  end

  describe '#[]' do
    before { collection << item1 }

    it 'returns item by key' do
      expect(collection['111']).to eq(item1)
    end
  end
end
