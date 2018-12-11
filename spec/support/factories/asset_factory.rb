# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    filename { Faker::File.unique.file_name('')[1..-1] }

    trait :with_topic do
      topic { build :topic }
    end
  end
end
