# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Git::Init do
  ##
  # Configuration
  #
  around do |example|
    temp_dir = Dir.mktmpdir

    OpenWebslides.configure do |config|
      ##
      # Absolute path to persistent repository storage
      #
      config.repository.path = temp_dir
    end

    example.run

    FileUtils.rm_rf temp_dir
  end

  ##
  # Subject
  #
  ##
  # Test variables
  #
  let(:repo) { Helpers::Committable::Repo.new create(:topic) }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  it 'creates the repository structure' do
    described_class.call repo

    expect(File).to exist File.join repo.path, '.git'
  end
end
