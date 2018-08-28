# frozen_string_literal: true

module OpenWebslides
  module Repo
    ##
    # Repository error
    #
    class RepoError < APIError
      def initialize(error_type = :api)
        super error_type
      end
    end
  end
end
