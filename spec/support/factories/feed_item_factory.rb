# frozen_string_literal: true

FactoryBot.define do
  factory :feed_item do
    feed_item_type { FeedItem.feed_item_types.keys.sample }
    user { build :user }
    topic { build :topic }
  end
end
