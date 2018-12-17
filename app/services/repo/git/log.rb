# frozen_string_literal: true

module Repo
  module Git
    ##
    # Get commit log
    #
    class Log < ApplicationService
      def call(repo)
        git = Rugged::Repository.new repo.path

        # Get a list of all commits, sorted from old to new
        git.walk('refs/heads/master', Rugged::SORT_REVERSE).map(&:oid)
      end
    end
  end
end
