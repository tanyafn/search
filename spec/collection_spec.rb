# frozen_string_literal: true

require 'spec_helper'

describe Collection do
  let(:item1) { { _id: '123', foo: :bar } }
  let(:item2) { { _id: '456', foo: :bar } }

  subject(:collection) { described_class.new }

  describe '#<<' do
    it 'adds one item into collection' do
      expect { collection << item1 }.to change { collection.get('123') }.from(nil).to(item1)
    end

    it 'adds multiple items into collection' do
      expect { collection << [item1, item2] }.to change {
        collection.get('123')
      }.from(nil).to(item1).and change {
        collection.get('456')
      }.from(nil).to(item2)
    end
  end

  describe '#get' do
    before { collection << [item1] }

    it 'returns item by key' do
      expect(collection.get('123')).to eq(item1)
    end
  end
end
