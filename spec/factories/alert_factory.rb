# frozen_string_literal: true

FactoryBot.define do
  factory :alert do
    user { build :user, :confirmed }

    factory :update_alert do
      alert_type { :topic_updated }

      topic { build :topic }
    end

    factory :pull_request_alert do
      alert_type { %i[pr_submitted pr_accepted pr_rejected].sample }

      pull_request { build :pull_request }
      subject { build :user }
    end
  end
end
