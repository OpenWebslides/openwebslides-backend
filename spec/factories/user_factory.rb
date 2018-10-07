# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password 6 }
    password_confirmation { password }
    tos_accepted { true }
    alert_emails { true }

    trait :with_topics do
      topics { build_list :topic, 3 }
    end

    trait :with_identities do
      identities { build_list :identity, 3 }
    end

    trait :confirmed do
      after :build, &:confirm
    end
  end
end
