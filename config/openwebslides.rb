# frozen_string_literal: true

##
# Open Webslides configuration
#
# This is the global platform configuration. This file allows administrators to configure the instance.
#
OpenWebslides.configure do |config|
  #########################################
  ##     Open Webslides configuration    ##
  #########################################

  ##
  # Temporary directory for uploads
  #
  config.tmpdir = Rails.root.join 'tmp', 'uploads'

  ##
  # Directory for filesystem locks
  #
  config.lockdir = Rails.root.join 'tmp', 'locks'

  #########################################
  ##      Repository configuration       ##
  #########################################

  ##
  # Absolute path to persistent repository storage
  #
  config.repository.path = Rails.root.join 'data'

  ##
  # Data format version (semver)
  #
  config.repository.version = '1.0.0'

  #########################################
  ##       Database configuration        ##
  #########################################

  ##
  # Database configuration is stored in `config/database.yml`
  #

  #########################################
  ##         OAuth2 configuration        ##
  #########################################

  ##
  # Google OAuth2 credentials
  #
  config.oauth2.google_id = ENV['OWS_GOOGLE_ID']
  config.oauth2.google_secret = ENV['OWS_GOOGLE_SECRET']

  ##
  # Facebook OAuth2 credentials
  #
  config.oauth2.facebook_id = ENV['OWS_FACEBOOK_ID']
  config.oauth2.facebook_secret = ENV['OWS_FACEBOOK_SECRET']

  #########################################
  ##           API configuration         ##
  #########################################

  ##
  # API version
  #
  config.api.version = YAML.load_file Rails.root.join 'config', 'version.yml'

  #########################################
  ##    Background queue configuration   ##
  #########################################

  ##
  # Lock timeout
  #
  config.queue.timeout = 10.seconds
end
