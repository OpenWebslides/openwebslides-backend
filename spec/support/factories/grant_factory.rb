# frozen_string_literal: true

FactoryBot.define do
  factory :grant do
    topic { build :topic }
    user { build :user }
  end
end
