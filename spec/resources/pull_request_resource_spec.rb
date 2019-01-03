# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequestResource, :type => :resource do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:resource) { described_class.new pull_request, context }

  ##
  # Test variables
  #
  let(:pull_request) { create :pull_request, :state => 'rejected', :feedback => 'feedback' }
  let(:context) { {} }

  ##
  # Tests
  #
  it { is_expected.to have_primary_key :id }

  it { is_expected.to have_attribute :message }
  it { is_expected.to have_attribute :feedback }
  it { is_expected.to have_attribute :state }

  it { is_expected.to be_immutable }

  it { is_expected.to have_one :user }
  it { is_expected.to have_one :source }
  it { is_expected.to have_one :target }

  it { is_expected.to have_metadata :created_at => pull_request.created_at.to_i.to_s }

  describe 'fields' do
    it 'has a valid set of fetchable fields' do
      expect(subject.fetchable_fields).to match_array %i[id message feedback state user source target]
    end

    it 'has a valid set of creatable fields' do
      expect(described_class.creatable_fields).to match_array %i[message user source target]
    end

    it 'has a valid set of updatable fields' do
      expect(described_class.updatable_fields).to match_array %i[state_event feedback]
    end

    it 'has a valid set of sortable fields' do
      expect(described_class.sortable_fields context).to match_array %i[id state]
    end
  end

  describe 'filters' do
    let(:verify) { described_class.filters[:state][:verify] }

    it 'has a valid set of filters' do
      expect(described_class.filters.keys).to match_array %i[id state]
    end

    it 'verifies state' do
      expect(verify.call(%w[ready foo accepted bar rejected], {}))
        .to match_array %w[ready accepted rejected]
    end
  end
end
