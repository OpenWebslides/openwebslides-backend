# frozen_string_literal: true

if Rails.env.production?
  Bugsnag.configure do |config|
    # Application version
    config.app_version = OpenWebslides.config.api.version

    # Docker hostname
    config.hostname = ENV['HOSTNAME']
  end
end
