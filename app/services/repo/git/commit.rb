# frozen_string_literal: true

module Repo
  module Git
    ##
    # Create a commit in repository
    #
    class Commit < ApplicationService
      def call(repo, user, message)
        git = Rugged::Repository.new repo.path

        git.checkout 'refs/heads/master' unless git.index.count.zero?

        # Prevent empty commits
        status = []
        git.status { |_, status_data| status.concat status_data }
        raise OpenWebslides::Repo::EmptyCommitError if status.empty?

        # Stage all changes
        index = git.index
        index.add_all

        commit_tree = index.write_tree git
        index.write

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
          :parents => git.empty? ? [] : [git.head.target],
          :tree => commit_tree,
          :update_ref => 'HEAD'
        }

        Rugged::Commit.create git, options
      end
    end
  end
end
