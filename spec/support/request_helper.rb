# frozen_string_literal: true

module RequestHelper
  def headers
    @headers ||= {
      'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    }
  end

  def add_content_type_header
    (@headers ||= headers)['Content-Type'] = 'application/vnd.api+json'
  end

  def add_auth_header
    (@headers ||= headers)['Authorization'] = "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
  end
end
