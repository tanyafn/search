# frozen_string_literal: true

require 'spec_helper'

describe Selectors::Base do
  let(:item1) { { _id: '111', name: 'Alice' } }
  let(:item2) { { _id: '222', name: 'Bob' } }
  let(:collection) { Collection.new(:users) << item1 << item2 }

  describe '#new' do
    context 'matching items exist' do
      let(:selector) { described_class.new(attribute: 'name', value: 'Alice') }

      it 'returns matching items' do
        expect(selector).to have_attributes(attribute: :name, value: 'Alice')
      end
    end
  end

  describe '#select_from' do
    context 'unknown attribute' do
      let(:selector) { described_class.new(attribute: 'unknown', value: 'Alice') }

      it 'raises an error' do
        expect { selector.select_from(collection) }.to raise_error(
          Selectors::UnknownAttribute, 'Unknown attribute unknown'
        )
      end
    end

    context 'known attribute' do
      let(:selector) { described_class.new(attribute: 'name', value: 'Alice') }

      it 'raises an error' do
        expect { selector.select_from(collection) }.to raise_error(
          RuntimeError, 'Not implemented'
        )
      end
    end
  end
end
