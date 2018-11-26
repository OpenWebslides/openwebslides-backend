# frozen_string_literal: true

module Repository
  ##
  # Read the contents of a repository
  #
  class Read < ApplicationService
    include Helpers::Lockable
    include Helpers::Committable

    def call(topic)
      read_lock topic do
        repo = find_repository topic

        Filesystem::Read.call repo
      end
    end
  end
end
