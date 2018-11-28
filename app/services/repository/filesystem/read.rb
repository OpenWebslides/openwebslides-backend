# frozen_string_literal: true

module Repository
  module Filesystem
    ##
    # Read contents of a repository
    #
    class Read < ApplicationService
      def call(repo)
        raise OpenWebslides::Repo::RepoDoesNotExistError unless Dir.exist? repo.path

        repo.validate_version!

        # Read all content item files into a list
        Dir[File.join repo.content_path, '*.yml'].map { |f| YAML.safe_load File.read f }
      end
    end
  end
end
