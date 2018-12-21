# frozen_string_literal: true

module Helpers
  ##
  # Make a repository read- and write-lockable
  #
  module Lockable
    ##
    # Lock a repository for writing (exclusive lock)
    #
    # Params:
    # +topic+:: Topic to write lock
    # +type+:: Lock constant, defaults to File::LOCK_EX
    # +block+:: Procedure to wrap in a write lock
    #
    def write_lock(topic, type = File::LOCK_EX, &block)
      file = File.join OpenWebslides.config.lockdir, "#{topic.id}.lock"

      lock file, type, &block
    end

    ##
    # Lock a repository for reading (shared lock)
    #
    # Params:
    # +topic+:: Topic to read lock
    # +type+:: Lock constant, defaults to File::LOCK_SH
    # +block+:: Procedure to wrap in a read lock
    #
    def read_lock(topic, type = File::LOCK_SH, &block)
      file = File.join OpenWebslides.config.lockdir, "#{topic.id}.lock"

      lock file, type, &block
    end

    private

    ##
    # Lock a file
    #
    # Params:
    # +file+:: File path to lock
    # +type+:: Lock type
    # +block+:: Procedure to execute while the file is locked
    #
    # Raises:
    # +OpenWebslides::TimeoutError+:: If the lock cannot be acquired within the configured timeout
    #
    def lock(file, type)
      File.open(file, File::RDWR | File::CREAT, 0o644) do |f|
        # rubocop:disable Style/ColonMethodCall
        result = Timeout::timeout(timeout, OpenWebslides::TimeoutError) do
          f.flock type
        end

        yield if result
      ensure
        f.flock File::LOCK_UN
      end
    end

    def timeout
      OpenWebslides.config.queue.timeout.to_i
    end
  end
end
