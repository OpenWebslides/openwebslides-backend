# frozen_string_literal: true

FactoryBot.define do
  factory :feed_item do
    event_type { FeedItem.event_types.keys.sample }
    user { build :user }
    topic { build :topic }
  end
end
