# frozen_string_literal: true

FactoryBot.define do
  factory :repository do
    topic { build :topic }
  end
end
