# frozen_string_literal: true

module Repo
  ##
  # Update the contents of a repository in the backing store
  #
  class Update < ApplicationService
    include Helpers::Lockable
    include Helpers::Committable

    def call(topic, content, user, message)
      write_lock topic do
        repo = repo_for topic

        # Write content items
        Repo::Filesystem::Write.call repo, content

        # Commit
        Repo::Git::Commit.call repo, user, message

        # Update timestamps
        topic.touch
      end
    end
  end
end
