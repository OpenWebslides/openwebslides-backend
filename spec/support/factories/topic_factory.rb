# frozen_string_literal: true

FactoryBot.define do
  factory :topic do
    ##
    # Attributes
    #
    title { Faker::Lorem.words(4).join ' ' }
    description { Faker::Lorem.words(20).join ' ' }
    root_content_item_id { Faker::Lorem.words(3).join '' }
    access { :public }

    ##
    # Associations
    #
    user { build :user, :confirmed }

    ##
    # Traits
    #
    trait :with_collaborators do
      collaborators { build_list :user, 3 }
    end

    trait :with_assets do
      assets { build_list :asset, 3 }
    end

    ##
    # Factories
    #
  end
end
