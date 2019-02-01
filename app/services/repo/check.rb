# frozen_string_literal: true

module Repo
  ##
  # Check if two repositories are mergeable
  #
  class Check < ApplicationService
    include Helpers::Lockable

    def call(source, target)
      source_repo = Repository.new :topic => source
      target_repo = Repository.new :topic => target

      remote_name = "topic_#{source.id}"

      read_lock source do
        read_lock target do
          ##
          # Step 1: Check if there are commits in source that are not present in target
          #
          # Get list of commits
          source_commits = Repo::Git::Log.call source_repo
          target_commits = Repo::Git::Log.call target_repo

          # Check if source has unique commits
          return false if (source_commits - target_commits).empty?

          begin
            ##
            # Step 2: Check if the repos can be merged without conflicts
            #
            # Add source repo remote and fetch
            Repo::Git::Remote::Add.call target_repo, remote_name, source_repo.path
            Repo::Git::Remote::Fetch.call target_repo, remote_name

            # Find out commit to merge
            commit = Repo::Git::Log.call(source_repo).last

            # Check if the commit can be merged into master
            Repo::Git::Check.call target_repo, commit
          ensure
            # Remove source repo remote
            Repo::Git::Remote::Remove.call target_repo, remote_name
          end
        end
      end
    end
  end
end
