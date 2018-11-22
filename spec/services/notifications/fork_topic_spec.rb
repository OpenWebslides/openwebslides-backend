# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::ForkTopic do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:topic) { create :topic, :upstream => create(:topic, :user => user) }
  let(:user) { create :user, :confirmed }

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

  context 'when the upstream topic owner has email notifications enabled' do
    let(:user) { create :user, :confirmed, :alert_emails => true }

    it 'sends an email' do
      expect(AlertMailer).to receive(:fork_topic).with instance_of Alert

      subject.call topic
    end
  end

  context 'when the upstream topic owner has email notifications disabled' do
    let(:user) { create :user, :confirmed, :alert_emails => false }

    it 'does not send an email' do
      expect(AlertMailer).not_to receive(:fork_topic).with instance_of Alert

      subject.call topic
    end
  end
end
