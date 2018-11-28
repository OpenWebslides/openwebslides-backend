# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Delete do
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
  before { Repository::Create.call topic }

  it 'deletes the directory structure' do
    subject.call topic

    expect(File).not_to exist repository_path
  end
end
