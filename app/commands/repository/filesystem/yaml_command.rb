# frozen_string_literal: true

module Repository
  module Filesystem
    class YAMLCommand < RepoCommand
      ##
      # Data format version (semantically versioned)
      #
      VERSION = '1.0.0'

      protected

      def content_path
        File.join repo_path, 'content'
      end

      def index_file
        File.join repo_path, 'content.yml'
      end

      # Validate the data format version
      def validate_version
        constraint = Semverse::Constraint.new "~> #{VERSION}"

        repository_version = YAML.safe_load(File.read index_file)['version']

        return if constraint.satisfies? repository_version

        error = "Cannot satisfy repository data format version #{repository_version}, server has #{VERSION}"
        raise OpenWebslides::FormatError, error
      end
    end
  end
end
