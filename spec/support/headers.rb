# frozen_string_literal: true

module Headers
  ##
  # Generate request headers
  #
  def headers(*headers)
    # Auto-generated headers
    request_headers = {
      'Content-Type' => JSONAPI::MEDIA_TYPE,
      'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    }

    # Custom headers
    headers.each do |header|
      case header
      when :refresh
        request_headers['Authorization'] = "Bearer #{JWT::Auth::RefreshToken.new(:subject => user).to_jwt}"
      when :access
        request_headers['Authorization'] = "Bearer #{JWT::Auth::AccessToken.new(:subject => user).to_jwt}"
      when nil
        next
      else
        raise "Header not recognized: #{header}"
      end
    end

    request_headers
  end
end
