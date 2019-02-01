# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Update do
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
  let(:repo) { Repository.new :topic => topic }

  let(:topic) { create :topic }

  let(:content) { [{ 'id' => topic.root_content_item_id, 'type' => 'contentItemTypes/ROOT' }, { 'id' => 'bar' }] }
  let(:user) { create :user }
  let(:message) { 'This is a commit message' }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before { Repo::Create.call topic }

  it 'writes the content' do
    subject.call topic, content, user, message

    expect(Dir.entries repo.content_path).to include "#{topic.root_content_item_id}.yml", 'bar.yml'
  end

  it 'creates a commit' do
    commit_count = `GIT_DIR=#{File.join repo.path, '.git'} git rev-list --count master`.to_i

    subject.call topic, content, user, message

    new_commit_count = `GIT_DIR=#{File.join repo.path, '.git'} git rev-list --count master`.to_i

    expect(new_commit_count).to eq commit_count + 1
  end

  it 'touches the topic' do
    timestamp = topic.updated_at

    sleep 1

    subject.call topic, content, user, message

    expect(topic.updated_at).to be > timestamp
  end
end
