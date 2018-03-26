# frozen_string_literal: true

module Repository
  module Filesystem
    ##
    # Read contents of local repository
    #
    class Read < RepoCommand
      def execute
        YAML.safe_load File.read repo_file
      end
    end
  end
end
