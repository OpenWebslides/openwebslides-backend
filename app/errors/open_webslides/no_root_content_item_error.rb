# frozen_string_literal: true

module OpenWebslides
  ##
  # No root content item found in the content
  #
  class NoRootContentItemError < FormatError
    def initialize
      super :no_root_content_item
    end
  end
end
