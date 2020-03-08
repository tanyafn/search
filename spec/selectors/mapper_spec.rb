# frozen_string_literal: true

require 'spec_helper'

describe Selectors::Mapper do
  subject(:selector) { described_class.resolve(query) }

  context 'selector for operator exist' do
    let(:query) do
      Query.new(
        collection: 'users',
        attribute: 'name',
        operator: '=',
        value: 'Francisca'
      )
    end

    it 'returns selector with expected attributes' do
      expect(selector).to be_a(Selectors::EqualTo)
      expect(selector).to have_attributes(attribute: :name, value: 'Francisca')
    end
  end

  context 'unknown operator' do
    let(:query) do
      Query.new(
        collection: 'users',
        attribute: 'name',
        operator: '<>',
        value: 'Francisca'
      )
    end

    it 'raises an error' do
      expect { selector }.to raise_error(Selectors::Mapper::UnknownOperator, 'Unknown operator <>')
    end
  end
end
