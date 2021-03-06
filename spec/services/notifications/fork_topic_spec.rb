# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::ForkTopic do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:topic) { create :topic, :upstream => upstream }
  let(:upstream) { create :topic, :user => user, :collaborators => collaborators }
  let(:user) { create :user, :confirmed, :alert_emails => alert_emails }
  let(:collaborators) { create_list :user, 3, :confirmed, :alert_emails => alert_emails }

  let(:alert_emails) { true }

  ##
  # Subject
  #
  ##
  # Stubs and mocks
  #
  let(:mail) { double 'Mail', :deliver_later => true }

  before do
    allow(AlertMailer).to receive(:fork_topic)
      .and_return mail
  end

  ##
  # Tests
  #
  it 'generates a feed item' do
    expect(FeedItem).to receive(:create)
      .with :feed_item_type => :topic_forked,
            :user => topic.user,
            :topic => topic

    subject.call topic
  end

  it 'generates an alert for the target topic owner and collaborators' do
    expect(Alert).to receive(:create)
      .with :alert_type => :topic_forked,
            :user => topic.upstream.user,
            :topic => topic.upstream,
            :subject => topic.user

    topic.upstream.collaborators.each do |collaborator|
      expect(Alert).to receive(:create)
        .with :alert_type => :topic_forked,
              :user => collaborator,
              :topic => topic.upstream,
              :subject => topic.user
    end

    subject.call topic
  end

  context 'when the upstream topic owner has email notifications enabled' do
    let(:user) { create :user, :confirmed, :alert_emails => true }

    it 'sends an email' do
      expect(AlertMailer).to receive(:fork_topic)
        .exactly(4).times
        .with instance_of Alert

      subject.call topic
    end
  end

  context 'when the upstream topic owner has email notifications disabled' do
    let(:user) { create :user, :confirmed, :alert_emails => false }

    it 'does not send an email' do
      expect(AlertMailer).not_to receive :fork_topic

      subject.call topic
    end
  end
end
