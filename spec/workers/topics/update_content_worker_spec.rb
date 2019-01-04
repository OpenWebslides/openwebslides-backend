# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::UpdateContentWorker do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # Subject
  #
  ##
  # Test variables
  #
  let(:topic) { create :topic }
  let(:user) { create :user }
  let(:file) { Tempfile.create.path }
  let(:message) { 'This is a message' }

  let(:upstream) { create :topic }
  let(:downstream) { create :topic, :upstream => upstream }

  let(:pr1) { create :pull_request, :user => user, :source => downstream, :target => upstream, :message => 'foo', :state => 'accepted' }
  let(:pr2) { create :pull_request, :user => user, :source => downstream, :target => upstream, :message => 'foo', :state => 'ready' }
  let(:pr3) { create :pull_request, :user => user, :source => downstream, :target => upstream, :message => 'foo', :state => 'incompatible' }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before do
    Repo::Create.call topic

    # Write temporary content file
    File.write file, 'foo'
  end

  it 'updates the content in the filesystem' do
    expect(Repo::Update).to receive(:call).with topic, 'foo', user, message

    subject.perform topic.id, file, user.id, message
  end

  context 'when the topic has open incoming pull requests' do
    before { pr1; pr2; pr3; Repo::Create.call upstream }

    it 'triggers a recheck on pr2 and pr3' do
      allow(Repo::Update).to receive(:call).with upstream, 'foo', user, message

      expect(PullRequests::CheckWorker).to receive(:perform_async).with pr2.id
      expect(PullRequests::CheckWorker).to receive(:perform_async).with pr3.id

      subject.perform upstream.id, file, user.id, message
    end
  end

  context 'when the topic has open outgoing pull requests' do
    before { pr1; pr2; pr3; Repo::Create.call downstream }

    it 'triggers a recheck on pr2 and pr3' do
      allow(Repo::Update).to receive(:call).with downstream, 'foo', user, message

      expect(PullRequests::CheckWorker).to receive(:perform_async).with pr2.id
      expect(PullRequests::CheckWorker).to receive(:perform_async).with pr3.id

      subject.perform downstream.id, file, user.id, message
    end
  end

  it 'creates appropriate notifications' do
    allow(Repo::Update).to receive(:call)
    expect(Notifications::UpdateTopic).to receive(:call).with topic, user

    subject.perform topic.id, file, user.id, message
  end

  it 'deletes the temporary file' do
    allow(Repo::Update).to receive :call

    subject.perform topic.id, file, user.id, message

    expect(File).not_to exist file
  end
end
