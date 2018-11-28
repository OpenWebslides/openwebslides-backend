# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Git::Init do
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
  let(:repo) { Helpers::Committable::Repo.new create(:topic) }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  it 'creates the repository structure' do
    subject.call repo

    expect(File).to exist File.join repo.path, '.git'
  end
end
