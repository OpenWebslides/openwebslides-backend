# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    ##
    # Attributes
    #
    filename { Faker::File.unique.file_name('')[1..-1] }

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
