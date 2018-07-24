# frozen_string_literal: true

module Versioning
  extend ActiveSupport::Concern

  included do
    # Verify the API version requested in the Accept header
    before_action :verify_accept_header_version
  end

  def verify_accept_header_version
    media_types = HTTP::Accept::MediaTypes.parse request.accept
    constraint = Semverse::Constraint.new "~> #{OpenWebslides.config.api.version}"

    request_version = Semverse::Version.new media_types.find { |mt| mt.parameters['version'] }
                                                       .parameters['version']

    return true if constraint.satisfies? request_version

    raise JSONAPI::Exceptions::UnacceptableVersionError, request_version.to_s
  end
end
