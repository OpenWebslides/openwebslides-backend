# frozen_string_literal: true

module Repository
  module Filesystem
    ##
    # Read contents of local repository
    #
    class Read < YAMLCommand
      def execute
        validate_version

        # Read all content item files into a list
        Dir[File.join content_path, '*.yml'].map { |f| YAML.safe_load File.read f }
      end
    end
  end
end
