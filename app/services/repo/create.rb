# frozen_string_literal: true

module Repo
  ##
  # Create a repository in the backing store
  #
  class Create < ApplicationService
    include Helpers::Lockable

    def call(topic)
      write_lock topic do
        repo = Repository.new :topic => topic

        # Create and populate local repository
        Repo::Filesystem::Init.call repo
        Repo::Git::Init.call repo

        # Initial commit
        # TODO: i18n
        Repo::Git::Commit.call repo,
                               topic.user,
                               'Initial commit'
      end
    end
  end
end
