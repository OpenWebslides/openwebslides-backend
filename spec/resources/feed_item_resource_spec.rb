# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedItemResource, :type => :resource do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  subject { described_class.new feed_item, context }

  let(:feed_item) { create :feed_item }
  let(:context) { {} }

  ##
  # Subject
  #

  ##
  # Tests
  #
  it { is_expected.to have_primary_key :id }

  it { is_expected.to be_immutable }

  it { is_expected.to have_attribute :event_type }
  it { is_expected.to have_attribute :topic_title }
  it { is_expected.to have_attribute :user_name }

  it { is_expected.to have_one(:user) }
  it { is_expected.to have_one(:topic) }

  describe 'fields' do
    it 'has a valid set of fetchable fields' do
      expect(subject.fetchable_fields).to match_array %i[id event_type topic_title user_name topic user]
    end

    it 'has a valid set of sortable fields' do
      expect(described_class.sortable_fields context).to match_array %i[created_at]
    end

    it 'sorts on descending :created_at by default' do
      expect(described_class.default_sort.first[:field]).to eq 'created_at'
      expect(described_class.default_sort.first[:direction]).to eq :desc
    end

    it { is_expected.to respond_to :meta }
  end

  describe 'filters' do
    it 'has a valid set of filters' do
      expect(described_class.filters.keys).to match_array %i[id event_type topic user]
    end

    describe 'event_type#verify' do
      subject { described_class.filters[:event_type][:verify] }

      it 'filters the right event types' do
        expect(subject.call %w[topic_created foobar topic_updated topic_forked TOPIC_CREATED TOPIC_UPDATED TOPIC_FORKED FOO FOOBAR]).to match_array %w[topic_created topic_updated topic_forked]
      end
    end
  end
end
