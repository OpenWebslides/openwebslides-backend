# frozen_string_literal: true

if Rails.env.production?
  Bugsnag.configure do |config|
    # Application version
    config.app_version = OpenWebslides.config.api.version

    # Hostname
    if File.exist? '/etc/dockerhosts'
      # Process is running in Docker container, parse Docker host /etc/hosts file
      config.hostname = `grep '127\.0\.0\.1' /etc/dockerhosts | grep -v localhost | head -1 | awk '{print $2}'`
    else
      config.hostname = `hostname --fqdn`
    end
  end
end
