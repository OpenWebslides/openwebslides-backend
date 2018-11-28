# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Read do
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

  it 'reads the repository contents' do
    expect(subject.call topic).to be_an Array
  end
end
