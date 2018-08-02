# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::RepoCommand do
  ##
  # Test variables
  #
  let(:topic) { create :topic }

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Tests
  #
  describe '#repo_path' do
    it 'points to a valid repository path' do
      expect(subject.send :repo_path).to eq File.join OpenWebslides.config.repository.path, topic.user.id.to_s, topic.id.to_s
    end
  end

  describe '#repo_file' do
    it 'points to a valid repository file' do
      expect(subject.send :repo_file).to eq File.join OpenWebslides.config.repository.path, topic.user.id.to_s, topic.id.to_s, 'data.json'
    end
  end
end
