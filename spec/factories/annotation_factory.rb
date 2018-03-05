# frozen_string_literal: true

FactoryBot.define do
  factory :annotation do
    content_item_id { Faker::Number.number 2 }
    user { build :user }
    topic { build :topic }

    factory :conversation, :class => Conversation do
      conversation_type { %i[question note].sample }
      title { Faker::Lorem.words(5).join(' ') }
      text { Faker::Lorem.sentence(3) }
    end

    factory :comment, :class => Comment do
      text { Faker::Lorem.sentence(3) }

      conversation do
        build :conversation, :topic => topic, :content_item_id => content_item_id
      end
    end
  end

  factory :rating do
    annotation { build :annotation }
    user { build :user }
  end
end
