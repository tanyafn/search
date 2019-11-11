# frozen_string_literal: true

require 'spec_helper'

describe Query do
  subject(:query) do
    described_class.new(
      collection: 'tickets',
      attribute: 'tags',
      operator: '=',
      value: 'value'
    )
  end

  specify do
    expect(subject).to have_attributes(
      collection: :tickets,
      attribute: :tags,
      operator: :'=',
      value: 'value'
    )
  end
end
