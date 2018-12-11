# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlertMailer do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  ##
  # Subject
  #
  let(:user) { create :user, :confirmed }

  ##
  # Tests
  #
  describe '#update_topic' do
    let(:mail) { described_class.update_topic alert }
    let(:alert) { create :update_alert, :user => user }

    it 'sets the headers' do
      expect(mail.subject).to match alert.topic.title
      expect(mail.to).to eq [user.email]
    end

    it 'sets the body' do
      expect(mail.body.encoded).to match alert.count.to_s
    end
  end

  describe '#submit_pr' do
    let(:mail) { described_class.submit_pr alert }
    let(:alert) { create :pull_request_alert, :alert_type => :pr_submitted, :user => user }

    it 'sets the headers' do
      expect(mail.subject).to match alert.topic.title
      expect(mail.to).to eq [user.email]
    end

    it 'sets the body' do
      expect(mail.body.encoded).to match alert.pull_request.message
    end
  end

  describe '#accept_pr' do
    let(:mail) { described_class.accept_pr alert }
    let(:alert) { create :pull_request_alert, :alert_type => :pr_accepted, :user => user }

    before { alert.pull_request.update :state => 'accepted', :feedback => 'feedback' }

    it 'sets the headers' do
      expect(mail.subject).to match alert.topic.title
      expect(mail.to).to eq [user.email]
    end

    it 'sets the body' do
      expect(mail.body.encoded).to match alert.pull_request.feedback
    end
  end

  describe '#reject_pr' do
    let(:mail) { described_class.reject_pr alert }
    let(:alert) { create :pull_request_alert, :alert_type => :pr_rejected, :user => user }

    before { alert.pull_request.update :state => 'rejected', :feedback => 'feedback' }

    it 'sets the headers' do
      expect(mail.subject).to match alert.topic.title
      expect(mail.to).to eq [user.email]
    end

    it 'sets the body' do
      expect(mail.body.encoded).to match alert.pull_request.feedback
    end
  end

  describe '#fork_topic' do
    let(:mail) { described_class.fork_topic alert }
    let(:alert) { create :forked_alert, :user => user }

    it 'sets the headers' do
      expect(mail.subject).to match alert.topic.title
      expect(mail.to).to eq [user.email]
    end

    it 'sets the body' do
      expect(mail.body.encoded).to match alert.subject.name.to_s
    end
  end
end
