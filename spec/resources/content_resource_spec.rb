# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentResource, :type => :resource do
  it 'should be abstract' do
    expect(described_class.abstract).to be true
  end
end
