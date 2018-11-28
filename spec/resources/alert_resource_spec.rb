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
  # Subject
  #
  subject(:resource) { described_class.new alert, context }

  ##
  # Test variables
  #
  let(:alert) { create :update_alert }
  let(:context) { {} }

  ##
  # Tests
  #
  it { is_expected.to have_primary_key :id }

  it { is_expected.to have_attribute :read }

  it { is_expected.to be_immutable }

  it { is_expected.to have_one :user }
  it { is_expected.to have_one :topic }
  it { is_expected.to have_one :pull_request }
  it { is_expected.to have_one(:subject).with_class_name('User') }

  it { is_expected.to have_metadata :created_at => alert.created_at.to_i.to_s }

  describe 'fields' do
    context 'when the alert is an UpdateAlert' do
      let(:alert) { create :update_alert }

      it 'has a valid set of fetchable fields' do
        expect(subject.fetchable_fields).to match_array %i[id alert_type count read user topic pull_request subject]
      end
    end

    context 'when the alert is a PullRequestAlert' do
      let(:alert) { create :pull_request_alert }

      it 'has a valid set of fetchable fields' do
        expect(subject.fetchable_fields).to match_array %i[id alert_type read user topic pull_request subject]
      end
    end

    it 'should have a valid set of updatable fields' do
      expect(described_class.updatable_fields).to match_array %i[read]
    end

    it 'has a valid set of sortable fields' do
      expect(described_class.sortable_fields context).to match_array %i[created_at]
    end

    it 'should sort on descending :created_at by default' do
      expect(described_class.default_sort.first[:field]).to eq 'created_at'
      expect(described_class.default_sort.first[:direction]).to eq :desc
    end
  end
end
