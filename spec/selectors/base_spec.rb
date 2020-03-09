# frozen_string_literal: true

require 'spec_helper'

describe Selectors::Base do
  let(:item) { { _id: '111', name: 'Alice' } }
  let(:collection) { Collection.new(:users) << item }
  let(:selector) { described_class.new(attribute: 'name', value: 'Alice') }

  describe '#new' do
    context 'matching items exist' do
      it 'returns matching items' do
        expect(selector).to have_attributes(attribute: :name, value: 'Alice')
      end
    end
  end

  describe '.handles?' do
    it 'raises a Not implemented error' do
      expect { described_class.handles?(:foo) }.to raise_error(
        RuntimeError, 'Not implemented'
      )
    end
  end

  describe '#perform' do
    it 'raises a Not implemented error' do
      expect { selector.perform(double, double, double) }.to raise_error(
        RuntimeError, 'Not implemented'
      )
    end
  end

  describe '#select_from' do
    context 'unknown attribute' do
      let(:selector) { described_class.new(attribute: 'unknown', value: 'Alice') }

      it 'raises an Unknown attribute error' do
        expect { selector.select_from(collection) }.to raise_error(
          Selectors::UnknownAttribute, 'Unknown attribute unknown'
        )
      end
    end

    context 'known attribute' do
      it 'raises a Not implemented error' do
        expect { selector.select_from(collection) }.to raise_error(
          RuntimeError, 'Not implemented'
        )
      end
    end
  end
end
