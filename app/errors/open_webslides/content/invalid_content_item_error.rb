# frozen_string_literal: true

module OpenWebslides
  module Content
    ##
    # Invalid content item - raised when a content item is not valid (has no identifier)
    #
    class InvalidContentItemError < ContentError
      def initialize
        super :invalid_content_item
      end
    end
  end
end
