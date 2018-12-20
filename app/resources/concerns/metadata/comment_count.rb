# frozen_string_literal: true

module Metadata
  ##
  # Add a `comment_count` metadata attribute
  #
  module CommentCount
    extend ActiveSupport::Concern

    included do
      # Add an entry lambda to resource metadata
      self.metadata += [lambda do |options, resource|
        {
          options[:serializer].key_formatter.format(:comment_count) => resource._model.comments.count
        }
      end]
    end
  end
end
