# frozen_string_literal: true

MEDIA_TYPE = 'application/vnd.openwebslides+json'

module Versioning
  extend ActiveSupport::Concern

  included do
    # Verify the API version requested in the Accept header
    before_action :verify_accept_header_version
  end

  # Verify if the current API version can satisfy the API version in the request's Accept header
  def verify_accept_header_version
    media_types = HTTP::Accept::MediaTypes.parse request.accept
    constraint = Semverse::Constraint.new "~> #{OpenWebslides.config.api.version}"

    # Select media types of format 'application/vnd.openwebslides+json; version=...'
    request_versions = media_types.select { |mt| mt.mime_type == MEDIA_TYPE && mt.parameters['version'] }
                                  .map { |mt| mt.parameters['version'] }

    # Check if version can be satisfied
    return true if request_versions.any? { |v| constraint.satisfies? v }

    raise JSONAPI::Exceptions::UnacceptableVersionError, request_versions.join(',')
  rescue HTTP::Accept::ParseError
    raise JSONAPI::Exceptions::UnacceptableVersionError, request.accept
  end
end
