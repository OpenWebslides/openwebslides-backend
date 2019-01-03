# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    ##
    # Attributes
    #
    ##
    # Associations
    #
    annotation { build :conversation }
    user { build :user }

    ##
    # Traits
    #
    ##
    # Factories
    #
  end
end
