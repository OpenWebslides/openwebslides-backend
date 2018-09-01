# frozen_string_literal: true

FactoryBot.define do
  factory :content do
    ##
    # Attributes
    #
    content_items { random_content }

    ##
    # Associations
    #
    topic { create :topic }

    ##
    # Traits
    #
    ##
    # Factories
    #
  end
end
