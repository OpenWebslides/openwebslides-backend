# frozen_string_literal: true

module Repo
  module Git
    ##
    # Check if a commit can be merged into master
    #
    class Check < ApplicationService
      def call(repo, commit)
        git = Rugged::Repository.new repo.path

        git.checkout 'refs/heads/master'

        # Create index from merged commits
        index = git.merge_commits git.head.target, commit

        # Return conflicts or not
        !index.conflicts?
      end
    end
  end
end
