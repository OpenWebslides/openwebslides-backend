# frozen_string_literal: true

FactoryBot.define do
  factory :commit do
    content_items { random_content }
    message { Faker::Lorem.words(6).join ' ' }
    topic { create :topic }
    user { create :user }
  end
end
