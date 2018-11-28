# frozen_string_literal: true

FactoryBot.define do
  factory :asset_token, :class => Asset::Token do
    ##
    # Attributes
    #
    ##
    # Associations
    #
    ##
    # Traits
    #
    trait :with_subject do
      subject { build :user }
    end

    trait :with_object do
      object { build :asset }
    end

    ##
    # Factories
    #
  end
end
