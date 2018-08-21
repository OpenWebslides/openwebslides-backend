# frozen_string_literal: true

module OpenWebslides
  ##
  # Content data format error
  #
  class FormatError < Error
    # Type of data format error, used for i18n string lookup
    attr_accessor :error_type

    def initialize(error_type = :format)
      @error_type = error_type
    end
  end
end
