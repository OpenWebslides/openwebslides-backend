# frozen_string_literal: true

module Repository
  module Filesystem
    ##
    # Destroy repository directory
    #
    class Destroy < YAMLCommand
      def execute
        FileUtils.rm_r repo_path, :secure => true
      end
    end
  end
end
