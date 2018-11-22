# frozen_string_literal:true

module Notifications
  ##
  # Generate feed item and alert when a comment is created
  #
  class CreateComment < ApplicationService
    def call(comment)
      # TODO: generate feed item

      # TODO: generate alert
      CommentMailer.create(comment).deliver_later
    end
  end
end
