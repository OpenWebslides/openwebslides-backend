# frozen_string_literal:true

module Annotations
  ##
  # Persist a new comment in the database
  #
  class CreateComment < ApplicationService
    def call(comment)
      if comment.save
        # Generate appropriate notifications
        Notifications::CreateComment.call comment
      end

      comment
    end
  end
end
