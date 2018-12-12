# frozen_string_literal: true

module OpenWebslides
  class LockManager
    def self.manager
      @manager ||= Redlock::Client.new [ENV['REDIS_URL'] || 'redis://localhost:6379']
    end

    def self.lock(key, &block)
      timeout = OpenWebslides.config.queue.timeout.in_milliseconds

      OpenWebslides::LockManager.manager.lock key, timeout, &block
    end

    def self.lock!(key, &block)
      timeout = OpenWebslides.config.queue.timeout.in_milliseconds

      OpenWebslides::LockManager.manager.lock! key, timeout, &block
    end
  end
end
