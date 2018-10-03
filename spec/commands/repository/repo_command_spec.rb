# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::RepoCommand do
  ##
  # Test variables
  #
  let(:topic) { create :topic }
  let(:topic2) { create :topic }

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Tests
  #
  describe '#repo_path' do
    it 'points to a valid repository path of the receiver' do
      expect(subject.send :repo_path).to eq File.join OpenWebslides.config.repository.path, topic.user.id.to_s, topic.id.to_s
    end

    it 'points to a valid repository path of another deck' do
      expect(subject.send :repo_path, topic2).to eq File.join OpenWebslides.config.repository.path, topic2.user.id.to_s, topic2.id.to_s
    end
  end
end
