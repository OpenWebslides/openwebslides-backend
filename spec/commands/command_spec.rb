# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Command do
  ##
  # Test variables
  #
  ##
  # Test subject
  #
  let(:subject) { described_class.new 'foo' }

  ##
  # Tests
  #
  it 'has a receiver' do
    expect(subject).to respond_to :receiver
    expect(subject.receiver).to eq 'foo'
  end

  it 'has an execute method' do
    expect(subject).to respond_to :execute
  end
end
