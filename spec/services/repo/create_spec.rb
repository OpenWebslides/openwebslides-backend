# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Create do
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

  let(:repository_path) { File.join OpenWebslides.config.repository.path, topic.user.id.to_s, topic.id.to_s }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  it 'creates the directory structure' do
    subject.call topic

    expect(File).to be_directory repository_path
    expect(File).to be_directory File.join repository_path, 'content'
    expect(File).to be_directory File.join repository_path, 'assets'
    expect(File).to exist File.join repository_path, 'content.yml'
  end

  it 'creates and initializes a git repository' do
    subject.call topic

    expect(File).to be_directory File.join repository_path, '.git'
  end

  it 'creates an initial commit' do
    subject.call topic

    expect(`GIT_DIR=#{File.join repository_path, '.git'} git rev-list --count master`.to_i).to eq 1
  end
end
