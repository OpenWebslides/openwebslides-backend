# frozen_string_literal: true

module Repository
  ##
  # Destroy a repository in the backing store
  #
  class Delete < RepoCommand
    def execute
      write_lock do
        # Delete local repository
        exec Filesystem::Destroy
      end
    end
  end
end
