# frozen_string_literal: true

module Repo
  module Git
    module Remote
      ##
      # Add a remote to a repository
      #
      class Add < ApplicationService
        def call(repo, name, path)
          git = Rugged::Repository.new repo.path

          git.remotes.create name, path
        end
      end
    end
  end
end
