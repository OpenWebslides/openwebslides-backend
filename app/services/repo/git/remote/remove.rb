# frozen_string_literal: true

module Repo
  module Git
    module Remote
      ##
      # Remove a remote from a repository
      #
      class Remove < ApplicationService
        def call(repo, name)
          git = Rugged::Repository.new repo.path

          git.remotes.delete name
        end
      end
    end
  end
end
