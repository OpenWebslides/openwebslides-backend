# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :be_compatible_with do |version|
  match do
    expect(subject.send :compatible_request_version?, version).to be true
  end
end
