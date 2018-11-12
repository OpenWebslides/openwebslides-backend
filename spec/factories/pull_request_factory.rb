# frozen_string_literal: true

FactoryBot.define do
  factory :pull_request do
    message { Faker::Lorem.words(20).join ' ' }
    feedback { Faker::Lorem.words(20).join ' ' }

    user { build :user, :confirmed }
    source { build :topic, :upstream => target }
    target { build :topic }
  end
end
