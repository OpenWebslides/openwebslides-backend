# frozen_string_literal: true

module Repo
  module Filesystem
    ##
    # Create and populate repository directory
    #
    class Init < ApplicationService
      def call(repo)
        # Create initial directory
        raise OpenWebslides::Repo::RepoExistsError if Dir.exist? repo.path

        FileUtils.mkdir_p repo.path

        # Write empty index file
        Repo::Filesystem::WriteIndex.call repo

        # Create content item directory
        FileUtils.mkdir_p repo.content_path
        FileUtils.touch File.join repo.content_path, '.keep'

        # Create asset directory
        FileUtils.mkdir_p repo.asset_path
        FileUtils.touch File.join repo.asset_path, '.keep'
      end
    end
  end
end
