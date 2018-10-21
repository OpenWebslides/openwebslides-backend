# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Init do
  ##
  # Test variables
  #
  let(:topic) { create :topic }

  let(:directory) { File.join Dir.mktmpdir('temp'), 'repository' }

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Stubs
  #
  before do
    # Mock repo_path
    allow(subject).to receive(:repo_path).and_return directory
  end

  ##
  # Tests
  #
  describe '#execute' do
    describe 'repository already exists' do
      let(:directory) { '/tmp' }

      it 'raises a RepoExistsError' do
        expect { subject.execute }.to raise_error OpenWebslides::Repo::RepoExistsError
      end
    end

    describe 'new repository' do
      it 'creates the repository structure' do
        subject.execute

        expect(File).to exist File.join directory, 'content.yml'
        expect(File).to exist File.join directory, 'assets', '.keep'
        expect(File).to exist File.join directory, 'content', '.keep'
      end
    end
  end
end
