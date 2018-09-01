# frozen_string_literal: true

FactoryBot.define do
  factory :content do
    content { random_content }
    topic { build :topic }
  end
end
