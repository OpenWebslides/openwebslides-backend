# frozen_string_literal: true

module Repo
  module Filesystem
    ##
    # Delete repository directory
    #
    class Delete < ApplicationService
      def call(repo)
        raise OpenWebslides::Repo::RepoDoesNotExistError unless Dir.exist? repo.path

        FileUtils.rm_r repo.path, :secure => true
      end
    end
  end
end
