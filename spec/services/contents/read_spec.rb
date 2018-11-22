# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contents::Read do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:topic) { create :topic }

  ##
  # Subject
  #
  ##
  # Stubs and mocks
  #
  before do
    Stub::Command.create Repository::Read
  end

  ##
  # Tests
  #
  it 'reads the contents of a topic' do
    dbl = double 'Repository::Read'

    expect(Repository::Read).to receive(:new)
      .with(instance_of Topic)
      .and_return dbl
    expect(dbl).to receive :execute

    subject.call topic
  end
end
