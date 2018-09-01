# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentResource, :type => :resource do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  before do
    Stub::Command.create Repository::Read
  end

  ##
  # Subject
  #
  subject(:resource) { described_class.new topic, context }

  ##
  # Test variables
  #
  let(:topic) { create :topic }
  let(:context) { {} }

  ##
  # Tests
  #
  it 'is abstract' do
    expect(described_class.abstract).to be true
  end

  ##
  # Test variables
  #
  let(:content) { build :content }
  let(:context) { {} }

  ##
  # Subject
  #
  subject { described_class.new content, context }

  ##
  # Tests
  #
  it { is_expected.to have_primary_key :id }

  it { is_expected.to have_attribute :content_items }

  it { is_expected.to have_one :topic }

  describe 'fields' do
    it 'has a valid set of fetchable fields' do
      expect(subject.fetchable_fields).to match_array %i[id content_items topic]
    end

    it 'has a valid set of creatable fields' do
      expect(described_class.creatable_fields).to be_empty
    end

    it 'has a valid set of updatable fields' do
      expect(described_class.updatable_fields).to be_empty
    end

    it 'has a valid set of sortable fields' do
      expect(described_class.sortable_fields).to be_empty
    end
  end

  describe 'methods' do
    describe '#content' do
      it 'reads the contents of a repository' do
        expect(Repository::Read).to receive(:call).with topic

        subject.content
      end
    end
  end
end
