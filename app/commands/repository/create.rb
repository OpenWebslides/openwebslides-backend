# frozen_string_literal: true

module Repository
  ##
  # Create a repository in the backing store
  #
  class Create < RepoCommand
    def execute
      write_lock do
        # Create and populate local repository
        exec Filesystem::Init
        exec Git::Init

        # Initial commit
        exec Git::Commit do |c|
          c.author = @receiver.user
          c.message = 'Initial commit'
          c.params = { :parents => [] }
        end
      end
    end
  end
end
