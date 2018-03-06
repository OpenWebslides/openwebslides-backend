# frozen_string_literal: true

module Repository
  module Filesystem
    ##
    # Read contents of local repository
    #
    class Read < RepoCommand
      def execute
        JSON.parse File.read repo_file
      end
    end
  end
end
