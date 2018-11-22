# frozen_string_literal: true

module Annotations
  ##
  # Update an annotation
  #
  class Update < ApplicationService
    def call(annotation, params)
      if params.key? :secret
        if params[:secret] == 'true' || params[:secret] == true
          annotation.protect
        else
          annotation.publish
        end
      else
        annotation.assign_attributes params.except :secret
        annotation.edit
      end

      annotation
    end
  end
end
