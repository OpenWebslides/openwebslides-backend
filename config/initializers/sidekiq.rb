# frozen_string_literal: true

# Perform Sidekiq jobs immediately in test,
# so you don't have to run a separate process.
# You'll also benefit from code reloading.
if Rails.env.test? || ENV['SIDEKIQ_INLINE']
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end
