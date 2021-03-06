# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::SubmitPR do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:pull_request) { create :pull_request, :target => target }
  let(:target) { create :topic, :user => owner, :collaborators => collaborators }

  let(:owner) { create :user, :confirmed, :alert_emails => alert_emails }
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
    allow(AlertMailer).to receive(:submit_pr)
      .and_return mail
  end

  ##
  # Tests
  #
  it 'generates an alert for the target topic owner and collaborators' do
    expect(Alert).to receive(:create)
      .with :alert_type => :pr_submitted,
            :user => target.user,
            :pull_request => pull_request,
            :topic => target,
            :subject => pull_request.user

    target.collaborators.each do |collaborator|
      expect(Alert).to receive(:create)
        .with :alert_type => :pr_submitted,
              :user => collaborator,
              :pull_request => pull_request,
              :topic => target,
              :subject => pull_request.user
    end

    subject.call pull_request
  end

  context 'when the target topic user and collaborators have email notifications enabled' do
    let(:alert_emails) { true }

    it 'sends an email' do
      expect(AlertMailer).to receive(:submit_pr)
        .exactly(4).times
        .with instance_of Alert

      subject.call pull_request
    end
  end

  context 'when the upstream topic owner has email notifications disabled' do
    let(:alert_emails) { false }

    it 'does not send an email' do
      expect(AlertMailer).not_to receive :submit_pr

      subject.call pull_request
    end
  end
end
