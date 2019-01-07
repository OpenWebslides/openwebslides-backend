# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Merge do
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

  let(:repository_path) { File.join OpenWebslides.config.repository.path, topic.user.id.to_s, topic.id.to_s }

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
    Repo::Update.call topic, content + [{ 'id' => 'content_item_id', 'value' => 'original' }], topic.user, '[upstream] Add content'

    sleep 1

    # Fork the repository
    Repo::Fork.call topic, fork

    # Populate the forked repository
    Repo::Update.call fork, content + [{ 'id' => 'content_item_id', 'value' => 'updated' }], fork.user, '[fork] Update content'
  end

  it 'merges the commits from the fork using a merge commit' do
    subject.call fork, topic, fork.user

    # 4 commits: 'Initial commit', '[upstream] Add content', '[fork] Update content', 'Merge pull request'
    expect(`cd #{repository_path} && git rev-list --count master`.to_i).to eq 4

    expect(Repo::Read.call topic).to match_array content + [{ 'id' => 'content_item_id', 'value' => 'updated' }]
  end

  it 'leaves no remotes in the repository' do
    subject.call fork, topic, fork.user

    expect(`cd #{repository_path} && git remote`).to be_empty
  end

  context 'when there is a conflict' do
    it 'raises a ConflictsError' do
      allow(Repo::Git::Merge).to receive(:call).and_raise OpenWebslides::Repo::ConflictsError

      expect { subject.call fork, topic, fork.user }.to raise_error OpenWebslides::Repo::ConflictsError
    end

    it 'leaves no remotes in the repository' do
      subject.call fork, topic, fork.user

      expect(`cd #{repository_path} && git remote`).to be_empty
    end
  end
end
