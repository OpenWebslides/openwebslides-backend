# frozen_string_literal: true

module Repository
  ##
  # Duplicate a repository in the backing store
  #
  class Fork < ApplicationService
    include Helpers::Lockable
    include Helpers::Committable

    def call(upstream, downstream)
      read_lock upstream do
        write_lock downstream do
          repo = find_repository upstream
          fork = find_repository downstream

          # Duplicate repository
          Repository::Filesystem::Fork.call repo, fork
        end
      end
    end
  end
end
