# frozen_string_literal: true

module OpenWebslides
  module Content
    ##
    # Invalid root content item - raised when the root content item id does not match the identifier in the database
    #
    class InvalidRootContentItemError < ContentError
      def initialize
        super :invalid_root_content_item
      end
    end
  end
end
