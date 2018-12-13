# frozen_string_literal: true

module Repo
  ##
  # Duplicate a repository in the backing store
  #
  class Fork < ApplicationService
    include Helpers::Lockable
    include Helpers::Committable

    def call(upstream, downstream)
      read_lock upstream do
        write_lock downstream do
          repo = repo_for upstream
          fork = repo_for downstream

          # Duplicate repository
          Repo::Filesystem::Fork.call repo, fork
        end
      end
    end
  end
end
