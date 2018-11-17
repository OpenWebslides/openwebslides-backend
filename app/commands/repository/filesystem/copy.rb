# frozen_string_literal: true

require 'fileutils'

module Repository
  module Filesystem
    ##
    # Duplicate repository
    #
    class Copy < YAMLCommand
      attr_accessor :fork

      def execute
        raise OpenWebslides::ArgumentError, 'No fork specified' unless @fork

        # Create initial directory
        raise OpenWebslides::Repo::RepoExistsError if Dir.exist? repo_path(@fork)

        FileUtils.mkdir_p repo_path(@fork)

        # Recursively copy repository
        FileUtils.cp_r File.join(repo_path, '.'), repo_path(@fork)
      end
    end
  end
end
