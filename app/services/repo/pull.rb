# frozen_string_literal: true

module Repo
  ##
  # Pull updates from one repo into another
  #
  class Pull < ApplicationService
    include Helpers::Lockable

    def call(source, target)
      # Repo that is most up to date
      source_repo = Repository.new :topic => source
      # Repo that will be fast forwarded
      target_repo = Repository.new :topic => target

      remote_name = "topic_#{source.id}"

      read_lock source do
        write_lock target do
          # Add source repo remote and fetch
          Repo::Git::Remote::Add.call target_repo, remote_name, source_repo.path
          Repo::Git::Remote::Fetch.call target_repo, remote_name

          # Find out last commit
          commit = Repo::Git::Log.call(source_repo).last

          # Perform fast forward
          Repo::Git::Checkout.call target_repo, commit
        end
      end
    ensure
      # Remove target's source remote
      Repo::Git::Remote::Remove.call target_repo, remote_name
    end
  end
end
