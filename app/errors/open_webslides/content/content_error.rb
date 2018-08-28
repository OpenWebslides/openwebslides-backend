# frozen_string_literal: true

module OpenWebslides
  module Content
    ##
    # Content data format error - raised when the content is malformed
    #
    class ContentError < APIError
      def initialize(error_type = :format)
        super error_type
      end
    end
  end
end
