# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    event_type { Notification.event_types.keys.sample }
    user { build :user }
    topic { build :topic }
  end
end
