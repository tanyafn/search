# frozen_string_literal: true

require 'spec_helper'

describe Selectors::IsUndefined do
  let(:collection) { (Collection.new(:users) << item1) << item2 }
  let(:item1) { { _id: '111', name: 'Alice', email: 'alice@exmple.com' } }
  let(:item2) { { _id: '222', name: 'Bob' } }

  subject(:selector) { described_class.new(params) }

  describe '#select_from' do
    subject(:selected_items) { described_class.new(params).select_from(collection) }

    context 'matching items exist' do
      let(:params) { { attribute: 'email' } }

      it 'returns matching items' do
        expect(selected_items).to eq([item2])
      end
    end

    context 'no matching items' do
      let(:params) { { attribute: 'name' } }

      it 'returns an empty array' do
        expect(selected_items).to eq([])
      end
    end

    context 'unknown attribute' do
      let(:params) { { attribute: 'none' } }

      it 'raises an error' do
        expect { selected_items }.to raise_error(
          Selectors::IsUndefined::UnknownAttribute,
          'Unknown attribute none'
        )
      end
    end
  end
end
