# frozen_string_literal: true

FactoryBot.define do
  factory :grant do
    ##
    # Attributes
    #
    ##
    # Associations
    #
    topic { build :topic }
    user { build :user }

    ##
    # Traits
    #
    ##
    # Factories
    #
  end
end
