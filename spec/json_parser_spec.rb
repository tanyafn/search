# frozen_string_literal: true

require 'spec_helper'

describe JsonParser do
  subject(:parsed_json) { described_class.parse(json_str) }

  describe '.parse' do
    context 'valid json' do
      let(:json_str) { [{ '_id' => '123', 'foo' => 'bar' }].to_json }

      it 'converts json into collection' do
        expect(parsed_json).to eq([{ _id: '123', foo: 'bar' }])
      end
    end

    context 'invalid json' do
      let(:json_str) { '' }

      it 'raises an error' do
        expect { subject }.to raise_error(JsonParser::BadData, 'Unexpected data format')
      end
    end
  end
end
