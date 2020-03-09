# frozen_string_literal: true

require 'spec_helper'

describe Selectors::EqualTo do
  let(:collection) { Collection.new(:users) << item1 << item2 }
  let(:item1) { { _id: '1', name: 'Alice', skills: %w[frontend design] } }
  let(:item2) { { _id: '2', name: 'Bob', skills: %w[frontend backend] } }

  describe '#select_from' do
    let(:selector) { described_class.new(params) }

    context 'matching items exist' do
      context 'single value' do
        let(:params) { { attribute: 'skills', value: 'frontend' } }

        it 'returns matching items' do
          expect(selector.select_from(collection)).to eq([item1, item2])
        end
      end

      context 'value is an array' do
        let(:params) { { attribute: 'skills', value: %w[design frontend] } }

        it 'returns matching items' do
          expect(selector.select_from(collection)).to eq([item1])
        end
      end
    end

    context 'no matching items' do
      let(:params) { { attribute: 'skills', value: 'math' } }

      it 'returns an empty array' do
        expect(selector.select_from(collection)).to eq([])
      end
    end
  end
end
