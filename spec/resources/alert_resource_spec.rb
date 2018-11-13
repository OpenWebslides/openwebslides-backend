# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlertResource, :type => :resource do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  let(:subject) { described_class.new alert, context }

  let(:alert) { create :alert }
  let(:context) { {} }

  ##
  # Tests
  #
  it { is_expected.to have_primary_key :id }

  it { is_expected.to have_attribute :read }

  it { is_expected.to be_immutable }

  it { is_expected.to have_one :user }
  it { is_expected.to have_one :topic }

  describe 'fields' do
    it 'has a valid set of fetchable fields' do
      expect(subject.fetchable_fields).to match_array %i[id alert_type read user topic]
    end

    it 'has a valid set of sortable fields' do
      expect(described_class.sortable_fields context).to match_array %i[created_at]
    end

    it 'should sort on descending :created_at by default' do
      expect(described_class.default_sort.first[:field]).to eq 'created_at'
      expect(described_class.default_sort.first[:direction]).to eq :desc
    end

    it { is_expected.to respond_to :meta }
  end
end
