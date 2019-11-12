# frozen_string_literal: true

require 'spec_helper'

describe JsonFileReader do
  describe '.read' do
    context 'data file with given name exists' do
      it 'returns parsed data' do
        expect(JsonFileReader.read('./spec/support/data/users.json').count).to eq(3)
      end
    end

    context 'data file with given name does not exist' do
      it 'raises an error' do
        expect {
          JsonFileReader.read('./spec/support/data/invalid_data_format.json')
        }.to raise_error(JsonFileReader::BadData)
      end
    end
  end
end
