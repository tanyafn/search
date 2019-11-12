# frozen_string_literal: true

require 'spec_helper'

describe DataSource do
  let(:path) { File.expand_path('./spec/data', Dir.pwd).freeze }
  subject(:data_source) { described_class.new(path) }

  describe '#[]' do
    context 'data file with given name exists' do
      it 'returns parsed data' do
        expect(data_source[:users].count).to eq(3)
      end
    end

    context 'data file with given name does not exist' do
      it 'raises an error' do
        expect { data_source[:invalid_data_format] }.to raise_error(DataSource::BadData)
      end
    end
  end
end
