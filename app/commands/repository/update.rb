# frozen_string_literal: true

module Repository
  ##
  # Update the contents of a repository in the backing store
  #
  class Update < RepoCommand
    attr_accessor :author, :content, :message

    def execute
      raise ArgumentError, 'No author specified' unless @author
      raise ArgumentError, 'No content specified' unless @content

      write_lock do
        # Write data file
        exec Filesystem::Write do |c|
          c.content = @content
        end

        # Commit
        exec Git::Commit do |c|
          c.author = @author
          c.message = @message || 'Update slidetopic'
        end

        # Update timestamps
        @receiver.touch
      end
    end
  end
end
