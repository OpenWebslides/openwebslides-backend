# frozen_string_literal: true

module Repo
  ##
  # Check if two repositories are mergeable
  #
  class Check < ApplicationService
    include Helpers::Lockable

    def call(source, target)
      read_lock source do
        read_lock target do
          source_repo = Repository.new :topic => source
          target_repo = Repository.new :topic => target

          # Get unsorted set of commits
          source_set = Set.new Repo::Git::Log.call source_repo
          target_set = Set.new Repo::Git::Log.call target_repo

          # Check if source is a proper (not equal) subset of target
          source_set.proper_subset? target_set
        end
      end
    end
  end
end
