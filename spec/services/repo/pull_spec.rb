# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Pull do
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
  let(:fork) { create :topic, :upstream => topic, :root_content_item_id => topic.root_content_item_id }

  let(:content) { [{ 'id' => topic.root_content_item_id, 'type' => 'contentItemTypes/ROOT' }] }
  let(:updated_content) { content + [{ 'id' => 'content_item_id', 'value' => 'original' }] }
  let(:more_updated_content) { updated_content + [{ 'id' => 'another_content_item_id', 'value' => 'updated' }] }
  let(:message) { 'Merge repository' }

  let(:repository_path) { File.join OpenWebslides.config.repository.path, fork.user.id.to_s, fork.id.to_s }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before do
    # Create the upstream repository
    Repo::Create.call topic

    sleep 1

    # Populate the upstream repository
    Repo::Update.call topic, updated_content, topic.user, '[upstream] Add content'

    sleep 1

    # Fork the repository
    Repo::Fork.call topic, fork

    # Populate the upstream repository a bit more
    Repo::Update.call topic, more_updated_content, fork.user, '[upstream] Add even more content'
  end

  it 'fast forwards the fork to the upstream' do
    subject.call topic, fork

    # 3 commits: 'Initial commit', '[upstream] Add content', '[upstream] Add even more content'
    expect(`cd #{repository_path} && git rev-list --count master`.to_i).to eq 3
    expect(Repo::Read.call topic).to match_array more_updated_content

  end

  it 'leaves no remotes in the repository' do
    subject.call topic, fork

    expect(`cd #{repository_path} && git remote`).to be_empty
  end
end
