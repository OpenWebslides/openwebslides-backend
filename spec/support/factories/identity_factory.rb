# frozen_string_literal: true

FactoryBot.define do
  factory :identity do
    uid { Faker::Internet.email }
    provider { Faker::Lorem.words 1 }
    user { build :user }
  end
end
