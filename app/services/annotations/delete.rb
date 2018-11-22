# frozen_string_literal: true

module Annotations
  ##
  # Delete an annotation
  #
  class Delete < ApplicationService
    def call(annotation)
      # Hide annotation text
      annotation.text = I18n.t 'openwebslides.annotations.hidden'

      # Allow deleting an annotation only if it is secret
      if annotation.secret?
        annotation.destroy
      else
        annotation.hide
      end

      annotation
    end
  end
end
