# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    ##
    # Attributes
    #
    # TODO: sample allowed file extensions
    filename { Faker::File.unique.file_name('', nil, %i[png jpeg gif webp].sample)[1..-1] }

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
