# frozen_string_literal: true

FactoryBot.define do
  factory :alert do
    user { build :user, :confirmed }

    factory :update_alert, :class => UpdateAlert do
      count { Faker::Number.number 1 }

      topic { build :topic }
    end
  end
end
