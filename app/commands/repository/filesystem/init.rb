# frozen_string_literal: true

require 'fileutils'

module Repository
  module Filesystem
    ##
    # Create and populate repository directory
    #
    class Init < RepoCommand
      def execute
        exec Filesystem::Create

        # Create initial files
        FileUtils.touch repo_file
      end
    end
  end
end
