# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :have_metadata do |metadata|
  match do |resource|
    expect(resource.meta(:serializer => DummySerializer.new)).to include metadata
  end
end
