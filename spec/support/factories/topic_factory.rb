# frozen_string_literal: true

FactoryBot.define do
  factory :topic do
    title { Faker::Lorem.words(4).join ' ' }
    description { Faker::Lorem.words(20).join ' ' }
    root_content_item_id { Faker::Lorem.words(3).join '' }
    state { :public_access }
    user { build :user, :confirmed }

    trait :with_collaborators do
      collaborators { build_list :user, 3 }
    end

    trait :with_assets do
      assets { build_list :asset, 3 }
    end

    trait :with_conversations do
      conversations { build_list :conversation, 3 }
    end
  end
end
