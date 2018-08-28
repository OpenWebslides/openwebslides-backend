# frozen_string_literal: true

module OpenWebslides
  module Content
    ##
    # Incompatible version - raised when a repository has a different, unsatisfiable version than the server
    #
    class IncompatibleVersionError < ContentError
      def initialize
        super :incompatible_version
      end
    end
  end
end
