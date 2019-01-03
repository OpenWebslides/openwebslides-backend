# frozen_string_literal: true

FactoryBot.define do
  factory :identity do
    ##
    # Attributes
    #
    uid { Faker::Internet.email }
    provider { Faker::Lorem.words 1 }

    ##
    # Associations
    #
    user { build :user }

    ##
    # Traits
    #
    ##
    # Factories
    #
  end
end
