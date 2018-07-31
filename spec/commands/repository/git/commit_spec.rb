# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Git::Commit do
  ##
  # Test variables
  #
  let(:topic) { create :topic }
  let(:user) { create :user }

  let(:repository) { double 'Rugged::Repository' }
  let(:commit) { double 'Rugged::Commit' }

  let(:repo_path) { Dir.mktmpdir 'repository' }

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Tests
  #
  describe '#execute' do
    before do
      # Create a test repository
      `cd "#{repo_path}" && git init && echo test > test && git add --all && git commit -m 'Initial commit'`
    end

    it 'adds a commit' do
      # Mock repo_path and repo_file
      allow(subject).to receive(:repo_path).and_return repo_path

      total_commits = `cd "#{repo_path}" && git rev-list HEAD --count`.to_i

      subject.author = user
      subject.message = 'Some commit message'

      subject.execute

      new_total_commits = `cd "#{repo_path}" && git rev-list HEAD --count`.to_i
      expect(new_total_commits).to be total_commits + 1
    end
  end
end
