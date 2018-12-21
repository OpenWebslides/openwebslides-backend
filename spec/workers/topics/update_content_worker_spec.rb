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

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before do
    Repository::Create.call topic

    # Write temporary content file
    File.write file, 'foo'
  end

  it 'updates the content in the filesystem' do
    expect(Repository::Update).to receive(:call).with topic, 'foo', user, message

    subject.perform topic.id, file, user.id, message
  end

  it 'creates appropriate notifications' do
    allow(Repository::Update).to receive(:call)
    expect(Notifications::UpdateTopic).to receive(:call).with topic, user

    subject.perform topic.id, file, user.id, message
  end

  it 'deletes the temporary file' do
    allow(Repository::Update).to receive :call

    subject.perform topic.id, file, user.id, message

    expect(File).not_to exist file
  end
end
