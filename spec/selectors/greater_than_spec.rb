# frozen_string_literal: true

require 'spec_helper'

describe Selectors::GreaterThan do
  let(:collection) { (Collection.new(:users) << item1) << item2 << item3 }
  let(:item1) { { _id: '111', name: 'Alice', last_visit: '2020-03-01' } }
  let(:item2) { { _id: '222', name: 'Bob', last_visit: '2020-02-01' } }
  let(:item3) { { _id: '333', name: 'Chloe' } }

  subject(:selector) { described_class.new(params) }

  describe '#select_from' do
    context 'matching items exist' do
      let(:params) { { attribute: 'last_visit', value: '2020-01-01' } }

      it 'returns matching items' do
        expect(selector.select_from(collection)).to eq([item1, item2])
      end
    end

    context 'no matching items' do
      let(:params) { { attribute: 'last_visit', value: '2020-03-01' } }

      it 'returns an empty array' do
        expect(selector.select_from(collection)).to eq([])
      end
    end

    context 'unknown attribute' do
      let(:params) { { attribute: 'unknown', value: '2020-03-01' } }

      it 'raises an error' do
        expect { selector.select_from(collection) }.to raise_error(
          Selectors::GreaterThan::UnknownAttribute,
          'Unknown attribute unknown'
        )
      end
    end
  end
end
