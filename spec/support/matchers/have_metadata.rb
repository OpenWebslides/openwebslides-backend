# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :have_metadata do |metadata|
  match do |actual|
    @actual = actual.meta(:serializer => DummySerializer.new)

    expect(@actual).to include metadata
  end

  diffable
end
