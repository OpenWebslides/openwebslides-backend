# frozen_string_literal: true

module Repository
  ##
  # Delete a repository in the backing store
  #
  class Delete < ApplicationService
    include Helpers::Lockable
    include Helpers::Committable

    def call(topic)
      write_lock topic do
        repo = repo_for topic

        # Delete repository
        Repository::Filesystem::Delete.call repo
      end
    end
  end
end
