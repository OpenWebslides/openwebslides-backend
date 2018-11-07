# frozen_string_literal: true

FactoryBot.define do
  factory :alert do
    user { build :user, :confirmed }
  end
end
