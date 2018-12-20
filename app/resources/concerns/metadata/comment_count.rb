# frozen_string_literal: true

module Metadata
  ##
  # Add a `comment_count` metadata attribute
  #
  module CommentCount
    extend ActiveSupport::Concern

    included do
      # Add an entry lambda to resource metadata
      self.metadata += [lambda do |_options, resource|
        {
          :comment_count => resource._model.comments.count
        }
      end]
    end
  end
end
