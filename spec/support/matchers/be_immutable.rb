# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :be_immutable do
  match do
    expect(described_class.immutable).to be true
  end
end
