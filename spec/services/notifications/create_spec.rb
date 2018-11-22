# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::Create do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:topic) { build :topic }

  ##
  # Subject
  #
  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  it 'generates a feed item' do
    expect(FeedItem).to receive(:create)
      .with :event_type => :topic_created,
            :user => topic.user,
            :topic => topic

    subject.call topic
  end

  describe 'return value' do
    subject { described_class.call topic }

    it { is_expected.to be_instance_of FeedItem }
  end
end
