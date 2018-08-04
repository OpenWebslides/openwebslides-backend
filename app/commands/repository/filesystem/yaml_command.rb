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

      # Validate the data format version
      def validate_version
        constraint = Semverse::Constraint.new "~> #{OpenWebslides.config.repository.version}"

        yaml = YAML.safe_load File.read index_file
        raise 'Version string not found' unless yaml&.key? 'version'

        repository_version = yaml['version']
        return if constraint.satisfies? repository_version

        raise "Cannot satisfy repository data format version #{repository_version}, server has #{VERSION}"
      rescue StandardError => e
        raise OpenWebslides::FormatError, e
      end
    end
  end
end
