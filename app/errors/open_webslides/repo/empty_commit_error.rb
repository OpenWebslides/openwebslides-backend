# frozen_string_literal: true

module OpenWebslides
  module Repo
    ##
    # Repo does not exist in the filesystem
    #
    class EmptyCommitError < Error; end
  end
end
