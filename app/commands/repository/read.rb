# frozen_string_literal: true

module Repository
  ##
  # Read the contents of a repository in the backing store
  #
  class Read < RepoCommand
    def execute
      read_lock do
        exec Filesystem::Read
      end
    end
  end
end
