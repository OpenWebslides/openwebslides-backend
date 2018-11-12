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
  # Test variables
  #
  let(:subject) { described_class.new pull_request, context }

  let(:pull_request) { create :pull_request }
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

  it { is_expected.to respond_to :meta }

  describe 'fields' do
    it 'has a valid set of fetchable fields' do
      expect(subject.fetchable_fields).to match_array %i[id message feedback state user source target]
    end

    it 'has a valid set of creatable fields' do
      expect(described_class.creatable_fields).to match_array %i[message user source target]
    end

    it 'has a valid set of sortable fields' do
      expect(described_class.sortable_fields context).to match_array %i[id state]
    end
  end

  describe 'filters' do
    it 'has a valid set of filters' do
      expect(described_class.filters.keys).to match_array %i[id state]
    end

    let(:verify) { described_class.filters[:state][:verify] }

    it 'should verify state' do
      expect(verify.call(%w[open foo accepted bar rejected], {}))
        .to match_array %w[open accepted rejected]
    end
  end
end
