# frozen_string_literal: true

module Helpers
  ##
  # Provide helpers for the repository
  #
  module Committable
    def find_repository(topic)
      Repo.new topic
    end

    class Repo
      attr_accessor :topic

      def initialize(topic)
        @topic = topic
      end

      ##
      # Root path to repository
      #
      def path
        File.join OpenWebslides.config.repository.path, topic.user.id.to_s, topic.id.to_s
      end

      ##
      # Path to repository content
      #
      def content_path
        File.join path, 'content'
      end

      ##
      # Path to repository assets
      #
      def asset_path
        File.join path, 'assets'
      end

      ##
      # Path to index file
      #
      def index
        File.join path, 'content.yml'
      end

      ##
      # Ensure the repository data format version is compatible
      #
      def validate_version!
        constraint = Semverse::Constraint.new "~> #{OpenWebslides.config.repository.version}"

        yaml = YAML.safe_load File.read index

        repository_version = yaml['version']
        raise OpenWebslides::IncompatibleVersionError unless constraint.satisfies? repository_version
      end
    end
  end
end
