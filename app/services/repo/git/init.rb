# frozen_string_literal: true

module Repo
  module Git
    ##
    # Create local repository
    #
    class Init < ApplicationService
      def call(repo)
        # Initialize local repo
        Rugged::Repository.init_at repo.path
      end
    end
  end
end
