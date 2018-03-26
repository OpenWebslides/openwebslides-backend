# frozen_string_literal: true

require 'fileutils'

module Repository
  module Filesystem
    ##
    # Create and populate repository directory
    #
    class Init < RepoCommand
      def execute
        # Create initial directory
        raise OpenWebslides::RepoExistsError if Dir.exist? repo_path
        FileUtils.mkdir_p repo_path

        # Create empty data file
        File.write repo_file, nil.to_yaml

        # Create asset directory
        FileUtils.mkdir_p File.join repo_path, 'assets'
        FileUtils.touch File.join repo_path, 'assets', '.keep'
      end
    end
  end
end
