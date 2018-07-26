# frozen_string_literal: true

module JSONAPI
  module Exceptions
    class UnacceptableVersionError < Error
      attr_accessor :request_version

      def initialize(request_version, error_object_overrides = {})
        @request_version = request_version
        super(error_object_overrides)
      end

      def errors
        api_version = OpenWebslides.config.api.version.to_s

        params = {
          :code => JSONAPI::NOT_ACCEPTABLE,
          :status => :not_acceptable,
          :title => I18n.translate('jsonapi-resources.exceptions.unacceptable_version.title'),
          :detail => I18n.translate('jsonapi-resources.exceptions.unacceptable_version.detail',
                                    :api_version => api_version,
                                    :request_version => @request_version)
        }

        [create_error_object(params)]
      end
    end
  end
end
