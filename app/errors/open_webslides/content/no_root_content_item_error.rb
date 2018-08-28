# frozen_string_literal: true

module OpenWebslides
  module Content
    ##
    # No root content item - raised when no root content item was found in the content
    #
    class NoRootContentItemError < ContentError
      def initialize
        super :no_root_content_item
      end
    end
  end
end
