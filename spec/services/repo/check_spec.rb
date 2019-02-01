# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Check do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # Subject
  #
  subject { described_class.call fork, topic }

  ##
  # Test variables
  #
  let(:topic) { create :topic }
  let(:fork) { create :topic, :upstream => topic, :root_content_item_id => topic.root_content_item_id }

  let(:root) { [{ 'id' => topic.root_content_item_id, 'type' => 'contentItemTypes/ROOT' }] }
  let(:content) { root + [{ 'id' => 'FILE_ONE', 'value' => 'FILE_ONE' }] }

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
    Repo::Update.call topic, root, topic.user, '[upstream] Commit A: add root content item'
    Repo::Update.call topic, content, topic.user, '[upstream] Commit B: add content to file one'

    sleep 1

    # Fork the repository
    Repo::Fork.call topic, fork
  end

  context 'when the fork has commit A' do
    before { `cd #{repository_path}; git reset --hard HEAD~` }

    it { is_expected.to be false }

    it 'leaves no remotes in the repository' do
      expect(`cd #{repository_path} && git remote`).to be_empty
    end
  end

  context 'when the fork has commit C' do
    before do
      `cd #{repository_path}; git reset --hard HEAD~~`
      Repo::Update.call fork,
                        content + [{ 'id' => 'FILE_TWO', 'value' => 'FILE_TWO' }],
                        fork.user,
                        '[fork] Commit C: add new content to file two'
    end

    it { is_expected.to be true }

    it 'leaves no remotes in the repository' do
      expect(`cd #{repository_path} && git remote`).to be_empty
    end
  end

  context 'when the fork has commits A and B' do
    it { is_expected.to be false }

    it 'leaves no remotes in the repository' do
      expect(`cd #{repository_path} && git remote`).to be_empty
    end
  end

  context 'when the fork has commits A, B and C (no conflicts)' do
    before do
      Repo::Update.call fork,
                        content + [{ 'id' => 'FILE_TWO', 'value' => 'FILE_TWO' }],
                        fork.user,
                        '[fork] Commit C: add content to file two'
    end

    it { is_expected.to be true }

    it 'leaves no remotes in the repository' do
      expect(`cd #{repository_path} && git remote`).to be_empty
    end
  end

  context 'when the fork has commits A and C (no conflicts)' do
    before do
      `cd #{repository_path}; git reset --hard HEAD~`
      Repo::Update.call fork,
                        content + [{ 'id' => 'FILE_TWO', 'value' => 'FILE_TWO' }],
                        fork.user,
                        '[fork] Commit C: add content to file two'
    end
    it { is_expected.to be true }

    it 'leaves no remotes in the repository' do
      expect(`cd #{repository_path} && git remote`).to be_empty
    end
  end

  context 'when the fork has commits A and D (conflicts)' do
    before do
      `cd #{repository_path}; git reset --hard HEAD~`
      Repo::Update.call fork,
                        content + [{ 'id' => 'FILE_ONE', 'value' => 'FILE_TWO' }],
                        fork.user,
                        '[fork] Commit D: add conflicting content to file one'
    end

    it { is_expected.to be false }

    it 'leaves no remotes in the repository' do
      expect(`cd #{repository_path} && git remote`).to be_empty
    end
  end

  context 'when the fork has commits A, B and D' do
    before do
      Repo::Update.call fork,
                        content + [{ 'id' => 'FILE_ONE', 'value' => 'FILE_TWO' }],
                        fork.user,
                        '[fork] Commit D: add conflicting content to file one'
    end

    it { is_expected.to be true }

    it 'leaves no remotes in the repository' do
      expect(`cd #{repository_path} && git remote`).to be_empty
    end
  end
end
