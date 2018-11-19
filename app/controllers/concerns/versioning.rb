# frozen_string_literal: true

module Versioning
  extend ActiveSupport::Concern

  included do
    # Verify the API version requested in the Accept header
    before_action :verify_accept_header_version
    after_action :add_content_type_header_version
  end

  # Verify if the current API version can satisfy the API version in the request's Accept header
  def verify_accept_header_version
    media_types = HTTP::Accept::MediaTypes.parse accept_header

    # Select media types of format 'application/vnd.openwebslides+json; version=...'
    request_versions = media_types.select { |mt| mt.mime_type == OpenWebslides::MEDIA_TYPE && mt.parameters['version'] }
                                  .map { |mt| mt.parameters['version'] }

    # Check if version can be satisfied
    return true if request_versions.any? { |v| compatible_request_version? v }

    raise JSONAPI::Exceptions::UnacceptableVersionError, request_versions.join(',')
  rescue HTTP::Accept::ParseError
    raise JSONAPI::Exceptions::UnacceptableVersionError, request.accept
  end

  # Add the current API version in the Content-Type response header
  def add_content_type_header_version
    media_type = "#{JSONAPI::MEDIA_TYPE}, #{OpenWebslides::MEDIA_TYPE}; version=#{OpenWebslides.config.api.version}"
    response.headers['Content-Type'] = media_type
  end

  protected

  # Check if the given version satisfies the server version
  def compatible_request_version?(request_version)
    Semverse::Constraint.new(request_version).satisfies? OpenWebslides.config.api.version
  end

  def accept_header
    request.accept || ''
  end
end
