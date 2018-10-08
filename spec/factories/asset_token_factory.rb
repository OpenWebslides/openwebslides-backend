# frozen_string_literal: true

FactoryBot.define do
  factory :asset_token do
    trait :with_subject do
      subject { build :user }
    end

    trait :with_object do
      object { build :asset }
    end
  end
end
