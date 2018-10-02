# frozen_string_literal: true

module Repository
  ##
  # Fork a repository in the backing store
  #
  class Fork < RepoCommand
    attr_accessor :fork

    def execute
      raise OpenWebslides::ArgumentError, 'No fork specified' unless @fork

      read_lock do
        exec Filesystem::Copy do |c|
          c.fork = @fork
        end
      end
    end
  end
end
