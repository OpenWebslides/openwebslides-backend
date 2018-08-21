# frozen_string_literal: true

module JSONAPI
  module Exceptions
    class FormatError < Error
      attr_accessor :error_type

      def initialize(error_type = :format, error_object_overrides = {})
        @error_type = error_type

        super error_object_overrides
      end

      def errors
        params = {
          :code => JSONAPI::VALIDATION_ERROR,
          :status => :unprocessable_entity,
          :title => I18n.translate("jsonapi-resources.exceptions.#{error_type}.title"),
          :detail => I18n.translate("jsonapi-resources.exceptions.#{error_type}.detail")
        }

        [create_error_object(params)]
      end
    end
  end
end
