# frozen_string_literal: true

module OpenWebslides
  ##
  # API error, base class of all errors thrown in the API
  #
  class APIError < Error
    # Type of error, used for i18n string lookup
    attr_accessor :error_type

    def initialize(error_type)
      @error_type = error_type
    end
  end
end
