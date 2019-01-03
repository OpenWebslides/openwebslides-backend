# frozen_string_literal: true

module Repo
  ##
  # Duplicate a repository in the backing store
  #
  class Fork < ApplicationService
    include Helpers::Lockable

    def call(upstream, downstream)
      read_lock upstream do
        write_lock downstream do
          repo = Repository.new :topic => upstream
          fork = Repository.new :topic => downstream

          # Duplicate repository
          Repo::Filesystem::Fork.call repo, fork
        end
      end
    end
  end
end
