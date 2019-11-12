# frozen_string_literal: true

require 'spec_helper'

describe DataSource do
  subject(:data_source) { described_class }

  describe '.[]' do
    context 'data file with given name exists' do
      skip 'returns parsed data' do
        expect(data_source[:users].count).to eq(2)
      end
    end

    context 'data file with given name does not exist' do
      skip 'raises an error' do
        expect { data_source[:none] }.to raise_error(DataSource::BadData)
      end
    end
  end
end
