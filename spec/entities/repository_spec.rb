# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:repository) { build :repository, :topic => topic }

  ##
  # Test variables
  #
  let(:topic) { create :topic }

  ##
  # Tests
  #
  describe 'associations' do
    it { is_expected.to validate_presence_of :topic }
  end

  describe 'methods' do
    describe '#path' do
      it 'returns the root path' do
        expect(repository.path).to eq File.join OpenWebslides.config.repository.path, topic.user.id.to_s, topic.id.to_s
      end

      it 'returns the root path joined by sub paths' do
        expect(repository.path 'foo', 'bar').to eq File.join OpenWebslides.config.repository.path, topic.user.id.to_s, topic.id.to_s, 'foo', 'bar'
      end
    end

    describe '#content_path' do
      it 'returns the content path' do
        expect(repository.content_path).to eq File.join OpenWebslides.config.repository.path, topic.user.id.to_s, topic.id.to_s, 'content'
      end
    end

    describe '#asset_path' do
      it 'returns the asset path' do
        expect(repository.asset_path).to eq File.join OpenWebslides.config.repository.path, topic.user.id.to_s, topic.id.to_s, 'assets'
      end
    end

    describe '#index' do
      it 'returns the index path' do
        expect(repository.index).to eq File.join OpenWebslides.config.repository.path, topic.user.id.to_s, topic.id.to_s, 'content.yml'
      end
    end

    describe '#==' do
      context 'when the topics are equal' do
        it { is_expected.to eq Repository.new(:topic => topic) }
      end

      context 'when the topics are not equal' do
        it { is_expected.not_to eq Repository.new(:topic => create(:topic)) }
      end
    end
  end
end
