# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    annotation { build :conversation }
    user { build :user }
  end
end
