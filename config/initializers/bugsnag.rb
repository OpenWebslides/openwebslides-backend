# frozen_string_literal: true

if Rails.env.production?
  Bugsnag.configure do |config|
    config.app_version = OpenWebslides.config.api.version
  end
end
