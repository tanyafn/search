# frozen_string_literal: true

require 'spec_helper'

describe Selectors::GreaterThan do
  let(:item1) { { _id: '1', name: 'Alice', last_visit: '2020-03-01' } }
  let(:item2) { { _id: '2', name: 'Bob', last_visit: '2020-02-01' } }
  let(:item3) { { _id: '3', name: 'Chloe' } }
  let(:collection) { Collection.new(:users) << item1 << item2 << item3 }

  let(:selector) { described_class.new(params) }

  describe '#select_from' do
    context 'matching items exist' do
      let(:params) { { attribute: 'last_visit', value: '2020-02-15' } }

      it 'returns matching items' do
        expect(selector.select_from(collection)).to eq([item1])
      end
    end

    context 'no matching items' do
      let(:params) { { attribute: 'last_visit', value: '2020-03-01' } }

      it 'returns an empty array' do
        expect(selector.select_from(collection)).to eq([])
      end
    end
  end
end
