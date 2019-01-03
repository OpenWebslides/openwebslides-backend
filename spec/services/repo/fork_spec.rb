# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Fork do
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
  let(:fork) { create :topic, :upstream => topic }

  let(:repository_path) { File.join OpenWebslides.config.repository.path, fork.user.id.to_s, fork.id.to_s }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before { Repo::Create.call topic }

  it 'creates the directory structure' do
    subject.call topic, fork

    expect(File).to be_directory repository_path
    expect(File).to be_directory File.join repository_path, 'content'
    expect(File).to be_directory File.join repository_path, 'assets'
    expect(File).to exist File.join repository_path, 'content.yml'
  end

  it 'copies the git repository' do
    subject.call topic, fork

    expect(File).to be_directory File.join repository_path, '.git'
  end

  it 'duplicates the repository' do
    subject.call topic, fork

    expect(`GIT_DIR=#{File.join repository_path, '.git'} git rev-list --count master`.to_i).to eq 1
  end
end
