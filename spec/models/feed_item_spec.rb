# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedItem, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:feed_item) { build :feed_item }

  ##
  # Test variables
  #
  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'attributes' do
    it { is_expected.to validate_presence_of :feed_item_type }

    it { is_expected.to define_enum_for(:feed_item_type).with %i[topic_created topic_updated topic_forked] }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:feed_items) }
    it { is_expected.to belong_to(:topic).inverse_of(:feed_items) }
  end
end
