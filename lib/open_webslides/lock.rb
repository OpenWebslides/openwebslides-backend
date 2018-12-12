# frozen_string_literal: true

module OpenWebslides
  class Lock
    def lock_manager
      @@lock_manager ||= Redlock::Client.new ENV['REDIS_URL'] || 'redis://localhost:6379'
    end
  end
end
