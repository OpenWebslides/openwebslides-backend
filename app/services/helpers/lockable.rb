# frozen_string_literal: true

module Helpers
  ##
  # Make a repository read- and write-lockable
  #
  module Lockable
    ##
    # Lock a repository for writing (exclusive lock)
    #
    def write_lock(topic, type = File::LOCK_EX, &block)
      lock topic, type, &block
    end

    ##
    # Lock a repository for reading (shared lock)
    #
    def read_lock(topic, type = File::LOCK_SH, &block)
      lock topic, type, &block
    end

    private

    def lock(topic, type)
      file = File.join OpenWebslides.config.lockdir, "#{topic.id}.lock"

      File.open(file, File::RDWR | File::CREAT, 0o644) do |lock|
        yield if lock.flock type
      ensure
        lock.flock File::LOCK_UN
      end
    end
  end
end
