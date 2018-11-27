# frozen_string_literal: true

module Helpers
  ##
  # Make a repository read- and write-lockable
  #
  module Lockable
    ##
    # Lock a repository for writing (exclusive lock)
    #
    def write_lock(topic, &block)
      lock topic, File::LOCK_EX, block
    end

    ##
    # Lock a repository for reading (shared lock)
    #
    def read_lock(topic, &block)
      lock topic, File::LOCK_SH, block
    end

    private

    def lock(topic, type, block)
      file = File.join OpenWebslides.config.lockdir, "#{topic.id}.lock"

      File.open(file, File::RDWR | File::CREAT, 0o644) do |lock|
        lock.flock type

        block.call
      ensure
        lock.flock File::LOCK_UN
      end
    end
  end
end
