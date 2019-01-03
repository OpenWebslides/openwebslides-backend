# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :be_abstract do
  match do
    expect(described_class.abstract).to be true
  end
end
