# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::Update do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:topic) { build :topic }
  let(:user) { build :user }

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
      .with :event_type => :topic_updated,
            :user => user,
            :topic => topic

    subject.call topic, user
  end

  describe 'return value' do
    subject { described_class.call topic, user }

    it { is_expected.to be_instance_of FeedItem }
  end
end
