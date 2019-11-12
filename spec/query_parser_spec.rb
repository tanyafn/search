# frozen_string_literal: true

require 'spec_helper'

describe QueryParser do
  describe '.parse' do
    subject { described_class.parse(query) }

    context 'when can parse query' do
      let(:queries) do
        [
          'select    users where _id = "test id"',
          ' SeLeCT    users  whERe _id =   "test id" '
        ]
      end

      it 'returns a Query object' do
        queries.each do |query|
          expect(described_class.parse(query)).to have_attributes(
            collection: :users,
            attribute: :_id,
            operator: :'=',
            value: 'test id'
          )
        end
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
