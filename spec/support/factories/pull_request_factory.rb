# frozen_string_literal: true

FactoryBot.define do
  factory :pull_request do
    ##
    # Attributes
    #
    message { Faker::Lorem.words(20).join ' ' }

    ##
    # Associations
    #
    user { build :user, :confirmed }
    source { build :topic, :upstream => target }
    target { build :topic }

    ##
    # Traits
    #
    ##
    # Factories
    #
  end
end
