# frozen_string_literal: true

require 'fileutils'

module Repository
  module Filesystem
    ##
    # Create and populate repository directory
    #
    class Init < YAMLCommand
      def execute
        # Create initial directory
        raise OpenWebslides::RepoExistsError if Dir.exist? repo_path

        FileUtils.mkdir_p repo_path

        # Create empty index file
        File.write index_file, { 'version' => OpenWebslides.config.repository.version }.to_yaml

        # Create content item directory
        FileUtils.mkdir_p File.join content_path
        FileUtils.touch File.join content_path, '.keep'

        # Create asset directory
        FileUtils.mkdir_p File.join repo_path, 'assets'
        FileUtils.touch File.join repo_path, 'assets', '.keep'
      end
    end
  end
end
