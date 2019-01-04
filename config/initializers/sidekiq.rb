# frozen_string_literal: true

# Perform Sidekiq jobs immediately in test,
# so you don't have to run a separate process.
# You'll also benefit from code reloading.
unless Rails.env.production? || ENV['SIDEKIQ_ASYNC']
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end
