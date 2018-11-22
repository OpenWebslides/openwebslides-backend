# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::Fork do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:topic) { create :topic, :upstream => create(:topic) }

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
      .with :event_type => :topic_forked,
            :user => topic.user,
            :topic => topic

    subject.call topic
  end

  it 'generates an alert' do
    expect(Alert).to receive(:create)
      .with :alert_type => :topic_forked,
            :user => topic.upstream.user,
            :subject => topic.user

    subject.call topic
  end

  describe 'return value' do
    subject { described_class.call topic }

    it { is_expected.to be_instance_of Alert }
  end
end
