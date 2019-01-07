# frozen_string_literal: true

module Repo
  module Git
    ##
    # Merge a commit into master
    #
    class Merge < ApplicationService
      def call(repo, commit, user, message)
        git = Rugged::Repository.new repo.path

        git.checkout 'refs/heads/master'

        # Create index from merged commits
        index = git.merge_commits git.head.target, commit

        # Conflict resolution has not been implemented yet
        raise OpenWebslides::Repo::ConflictsError if index.conflicts?

        commit_tree = index.write_tree git
        git.checkout_tree commit_tree

        # Author object
        commit_author = {
          :email => user.email,
          :name => user.name,
          :time => Time.now
        }

        # Commit options
        options = {
          :author => commit_author,
          :committer => commit_author,
          :message => message,
          :parents => [git.head.target, commit],
          :tree => commit_tree,
          :update_ref => 'HEAD'
        }

        Rugged::Commit.create git, options
      end
    end
  end
end
