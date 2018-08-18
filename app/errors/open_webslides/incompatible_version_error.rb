# frozen_string_literal: true

module OpenWebslides
  ##
  # Incompatible version - raised when a repository has a different, unsatisfiable version than the server
  #
  class IncompatibleVersionError < FormatError
    def initialize
      super :incompatible_version
    end
  end
end
