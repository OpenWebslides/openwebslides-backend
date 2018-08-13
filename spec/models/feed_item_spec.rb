# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedItem, :type => :model do
  describe 'attributes' do
    it { is_expected.not_to allow_value(nil).for(:event_type) }
    it { is_expected.not_to allow_value('').for(:event_type) }

    it 'is invalid without attributes' do
      expect(FeedItem.new).not_to be_valid
    end

    it 'is valid with attributes' do
      feed_item = build :feed_item
      expect(feed_item).to be_valid
    end

    it 'has a valid :event_type enum' do
      expect(%w[topic_created topic_updated]).to eq FeedItem.event_types.keys
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:feed_items) }
    it { is_expected.to belong_to(:topic).inverse_of(:feed_items) }
  end
end
