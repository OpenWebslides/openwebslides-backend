# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contents::Update do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:topic) { build :topic }
  let(:user) { build :user }
  let(:content) { 'content' }
  let(:message) { Faker::Lorem.words(10).join ' ' }

  ##
  # Subject
  #
  ##
  # Stubs and mocks
  #
  before do
    Stub::Command.create Repository::Update, %i[author= content= message=]
  end

  ##
  # Tests
  #
  it 'updates the contents of a topic' do
    dbl = double 'Repository::Create'

    expect(Repository::Update).to receive(:new)
      .with(instance_of Topic)
      .and_return dbl

    expect(dbl).to receive(:author=).with user
    expect(dbl).to receive(:content=).with content
    expect(dbl).to receive(:message=).with message

    expect(dbl).to receive :execute

    subject.call topic, user, content, message
  end

  it 'creates appropriate notifications' do
    expect(Notifications::Update).to receive(:call).with topic, user

    subject.call topic, user, content, message
  end
end
