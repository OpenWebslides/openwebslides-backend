# frozen_string_literal: true

module Repo
  module Git
    module Remote
      ##
      # Fetch a remote
      #
      class Fetch < ApplicationService
        def call(repo, name)
          git = Rugged::Repository.new repo.path

          git.remotes[name].fetch
        end
      end
    end
  end
end
