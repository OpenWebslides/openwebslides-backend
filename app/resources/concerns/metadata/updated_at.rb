# frozen_string_literal: true

module Metadata
  ##
  # Add a `updated_at` metadata attribute
  #
  module UpdatedAt
    extend ActiveSupport::Concern

    included do
      # Add an entry lambda to resource metadata
      self.metadata += [lambda do |_options, resource|
        {
          :updated_at => DateValueFormatter.format(resource._model.updated_at)
        }
      end]
    end
  end
end
