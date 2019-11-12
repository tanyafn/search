# frozen_string_literal: true

require 'spec_helper'

describe Selectors::Equality do
  let(:collection) { (Collection.new(:users) << item1) << item2 }
  let(:item1) { { _id: '111', name: 'Alice', skills: %w[frontend design] } }
  let(:item2) { { _id: '222', name: 'Bob', skills: %w[frontend backend] } }

  subject(:selector) { described_class.new(params) }

  describe '#select_from' do
    context 'matching items exist' do
      let(:params) { { attribute: 'skills', value: 'frontend' } }

      it 'returns matching items' do
        expect(selector.select_from(collection)).to eq([item1, item2])
      end
    end

    context 'no matching items' do
      let(:params) { { attribute: 'skills', value: 'math' } }

      it 'returns an empty array' do
        expect(selector.select_from(collection)).to eq([])
      end
    end

    context 'unknown attribute' do
      let(:params) { { attribute: 'none', value: 'math' } }

      it 'raises an error' do
        expect { selector.select_from(collection) }.to raise_error(
          Selectors::Equality::UnknownAttribute,
          'Unknown attribute none'
        )
      end
    end
  end
end
