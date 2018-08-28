# frozen_string_literal: true

module Repository
  module Filesystem
    class YAMLCommand < RepoCommand
      protected

      def content_path
        File.join repo_path, 'content'
      end

      def index_file
        File.join repo_path, 'content.yml'
      end

      ##
      # Ensure the repository data format version is compatible
      #
      def validate_version
        constraint = Semverse::Constraint.new "~> #{OpenWebslides.config.repository.version}"

        yaml = YAML.safe_load File.read index_file

        repository_version = yaml['version']
        raise OpenWebslides::Content::IncompatibleVersionError unless constraint.satisfies? repository_version
      end

      ##
      # Write repository index file containing version information and reference to root content item
      #
      def write_index(attrs = {})
        index_hash = attrs.merge 'version' => OpenWebslides.config.repository.version

        File.write index_file, index_hash.to_yaml
      end
    end
  end
end
