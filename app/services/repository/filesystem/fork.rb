# frozen_string_literal: true

require 'fileutils'

module Repository
  module Filesystem
    ##
    # Duplicate repository
    #
    class Fork < ApplicationService
      def call(repo, fork)
        raise OpenWebslides::Repo::RepoDoesNotExistError unless Dir.exist? repo.path
        raise OpenWebslides::Repo::RepoExistsError if Dir.exist? fork.path

        # Create initial directory
        FileUtils.mkdir_p fork.path

        # Recursively copy repository
        FileUtils.cp_r File.join(repo.path, '.'), fork.path
      end
    end
  end
end
