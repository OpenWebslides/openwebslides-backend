# frozen_string_literal: true

FactoryBot.define do
  factory :content do
    ##
    # Attributes
    #
    content { random_content }

    ##
    # Associations
    #
    topic { build :topic }

    ##
    # Traits
    #
    ##
    # Factories
    #
  end
end
