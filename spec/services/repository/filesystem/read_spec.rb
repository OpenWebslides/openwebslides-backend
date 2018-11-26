# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Read do
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
  context 'when the repository does not exist' do
    it 'raises a RepoDoesNotExistError' do
      expect { subject.call repo }.to raise_error OpenWebslides::RepoDoesNotExistError
    end
  end

  context 'when the repository already exists' do
    before { Repository::Create.call repo.topic }

    subject { described_class.call repo }

    it { is_expected.to be_an Array }
  end
end
