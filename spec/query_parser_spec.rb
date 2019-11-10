# frozen_string_literal: true

require 'spec_helper'

describe QueryParser do
  describe '.parse' do
    subject { described_class.parse(query) }

    context 'when can parse query' do
      let(:query) { 'SeLeCT    users where _id= "test id"' }

      it 'returns Query object' do
        expect(subject).to be_a(Query)

        expect(subject).to have_attributes(
          collection: 'users',
          attribute: '_id',
          operator: '=',
          value: 'test id'
        )
      end
    end

    context 'when cannot parse query' do
      let(:query) { 'invalid query' }

      it 'raises an error' do
        expect { subject }.to raise_error(QueryParser::BadData, 'Unexpected query format')
      end
    end
  end
end
