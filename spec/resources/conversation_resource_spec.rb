# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConversationResource, :type => :resource do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:resource) { described_class.new conversation, context }

  ##
  # Test variables
  #
  let(:conversation) { create :conversation }
  let(:context) { {} }

  ##
  # Tests
  #
  it { is_expected.to have_primary_key :id }

  it { is_expected.to have_attribute :content_item_id }
  it { is_expected.to have_attribute :conversation_type }
  it { is_expected.to have_attribute :title }
  it { is_expected.to have_attribute :text }

  it { is_expected.to have_one :user }
  it { is_expected.to have_one :topic }
  it { is_expected.to have_many :comments }

  it { is_expected.to have_metadata :comment_count => conversation.comments.count, :created_at => conversation.created_at.to_i.to_s }

  describe 'fields' do
    it 'should have a valid set of fetchable fields' do
      expect(subject.fetchable_fields).to match_array %i[id content_item_id user topic conversation_type title text comments rating rated secret edited flagged deleted]
    end

    context 'hidden state' do
      before { conversation.hide }

      it 'should have a valid set of fetchable fields' do
        expect(subject.fetchable_fields).to match_array %i[id content_item_id user topic conversation_type comments rating rated secret edited flagged deleted]
      end
    end

    it 'should have a valid set of updatable fields' do
      expect(described_class.updatable_fields).to match_array %i[title text secret]
    end

    it 'should have a valid set of sortable fields' do
      expect(described_class.sortable_fields context).to match_array %i[id content_item_id conversation_type title text rating rated secret edited flagged deleted]
    end
  end

  describe 'filters' do
    it 'should have a valid set of filters' do
      expect(described_class.filters.keys).to match_array %i[id user content_item_id conversation_type rated]
    end
  end
end
