# frozen_string_literal: true

module Repo
  ##
  # Delete a repository in the backing store
  #
  class Delete < ApplicationService
    include Helpers::Lockable

    def call(topic)
      write_lock topic do
        repo = Repository.new :topic => topic

        # Delete repository
        Repo::Filesystem::Delete.call repo

        # Update timestamps
        topic.touch
      end
    end
  end
end
