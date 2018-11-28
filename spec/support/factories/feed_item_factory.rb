# frozen_string_literal: true

FactoryBot.define do
  factory :feed_item do
    ##
    # Attributes
    #
    feed_item_type { FeedItem.feed_item_types.keys.sample }

    ##
    # Associations
    #
    user { build :user }
    topic { build :topic }

    ##
    # Traits
    #
    ##
    # Factories
    #
  end
end
