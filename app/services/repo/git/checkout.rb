# frozen_string_literal: true

module Repo
  module Git
    ##
    # Check out a commit
    #
    class Checkout < ApplicationService
      def call(repo, commit)
        git = Rugged::Repository.new repo.path

        git.checkout 'refs/heads/master'

        git.checkout_tree commit
        git.references.update git.head.resolve, commit
      end
    end
  end
end
