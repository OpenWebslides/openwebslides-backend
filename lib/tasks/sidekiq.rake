# frozen_string_literal: true

require 'sidekiq/api'

namespace :sidekiq do
  desc 'Clear the Sidekiq queue'
  task :clear => :environment do
    # Retry jobs
    set = Sidekiq::RetrySet.new
    puts "Clearing #{set.count} retry jobs"
    set.clear

    # Scheduled jobs
    set = Sidekiq::ScheduledSet.new
    puts "Clearing #{set.count} scheduled jobs"
    set.clear
  end
end
