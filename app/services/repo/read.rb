# frozen_string_literal: true

module Repo
  ##
  # Read the contents of a repository
  #
  class Read < ApplicationService
    include Helpers::Lockable

    def call(topic)
      read_lock topic do
        repo = Repository.new :topic => topic

        Filesystem::Read.call repo
      end
    end
  end
end
