# frozen_string_literal: true

FactoryBot.define do
  factory :conversion do
    filename { File.basename Faker::File.file_name }
    name { filename.split('.').first }
    status { %i[queued processing success error].sample }

    user { build :user }
    deck { build :deck }
  end
end
