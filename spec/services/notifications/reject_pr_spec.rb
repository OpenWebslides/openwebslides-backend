# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::RejectPR do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:pull_request) { create :pull_request, :source => source, :target => target }
  let(:source) { create :topic, :user => owner, :collaborators => collaborators, :upstream => target, :root_content_item_id => target.root_content_item_id }
  let(:target) { create :topic }

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
    allow(AlertMailer).to receive(:reject_pr)
      .and_return mail
  end

  ##
  # Tests
  #
  it 'generates an alert for the source topic owner and collaborators' do
    expect(Alert).to receive(:create)
      .with :alert_type => :pr_rejected,
            :user => source.user,
            :pull_request => pull_request,
            :topic => target,
            :subject => target.user

    source.collaborators.each do |collaborator|
      expect(Alert).to receive(:create)
        .with :alert_type => :pr_rejected,
              :user => collaborator,
              :pull_request => pull_request,
              :topic => target,
              :subject => target.user
    end

    subject.call pull_request
  end

  context 'when the target topic owner and collaborators have email notifications enabled' do
    let(:alert_emails) { true }

    it 'sends an email' do
      expect(AlertMailer).to receive(:reject_pr)
        .exactly(4).times
        .with instance_of(Alert)

      subject.call pull_request
    end
  end

  context 'when the target topic owner and collaborators have email notifications disabled' do
    let(:alert_emails) { false }

    it 'does not send an email' do
      expect(AlertMailer).not_to receive(:reject_pr)

      subject.call pull_request
    end
  end
end
