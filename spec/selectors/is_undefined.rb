# frozen_string_literal: true

require 'spec_helper'

describe Selectors::IsUndefined do
  let(:item1) { { _id: '1', name: 'Alice', email: 'alice@exmple.com' } }
  let(:item2) { { _id: '2', name: 'Bob' } }
  let(:collection) { Collection.new(:users) << item1 << item2 }

  let(:selector) { described_class.new(params) }

  describe '#select_from' do
    context 'matching items exist' do
      let(:params) { { attribute: 'email' } }

      it 'returns matching items' do
        expect(selector.select_from(collection)).to eq([item2])
      end
    end

    context 'no matching items' do
      let(:params) { { attribute: 'name' } }

      it 'returns an empty array' do
        expect(selector.select_from(collection)).to eq([])
      end
    end
  end
end
