# frozen_string_literal: true

FactoryBot.define do
  factory :alert do
    ##
    # Attributes
    #
    ##
    # Associations
    #
    user { build :user, :confirmed }

    ##
    # Traits
    #
    ##
    # Factories
    #
    factory :update_alert do
      alert_type { :topic_updated }
      count { Faker::Number.number 1 }

      topic { build :topic }
    end

    factory :pull_request_alert do
      alert_type { %i[pr_submitted pr_accepted pr_rejected].sample }

      pull_request { build :pull_request }
      topic { pull_request.target }
      subject { build :user }
    end

    factory :forked_alert do
      alert_type { :topic_forked }

      topic { build :topic }
      subject { build :user }
    end
  end
end
