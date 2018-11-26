# frozen_string_literal: true

module Repository
  ##
  # Create a repository in the backing store
  #
  class Create < ApplicationService
    include Helpers::Lockable
    include Helpers::Committable

    def call(topic)
      write_lock topic do
        repo = find_repository topic

        # Create and populate local repository
        Repository::Filesystem::Init.call repo
        Repository::Git::Init.call repo

        # Initial commit
        # TODO: i18n
        Repository::Git::Commit.call repo,
                                     topic.user,
                                     'Initial commit'
      end
    end
  end
end
