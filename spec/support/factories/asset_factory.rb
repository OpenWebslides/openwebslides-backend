# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    ##
    # Attributes
    #
    # TODO: sample allowed file extensions
    filename { "#{Faker::Lorem.unique.words(5).join}.#{%i[png jpeg gif webp].sample}" }

    ##
    # Associations
    #
    ##
    # Traits
    #
    trait :with_topic do
      topic { build :topic }
    end

    ##
    # Factories
    #
  end
end
