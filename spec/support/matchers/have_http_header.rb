# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :have_http_header do |headers|
  match do
    @actual = response.headers.to_h

    expect(@actual).to include headers
  end

  diffable
end
