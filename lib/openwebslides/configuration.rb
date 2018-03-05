# frozen_string_literal: true

require 'ostruct'

module OpenWebslides
  class << self
    attr_accessor :config

    ##
    # Configure the Open Webslides platform
    # Yields an instance of OpenWebslides::Configuration
    #
    def configure
      @config ||= OpenWebslides::Configuration.new
      yield @config
      @config.verify!
    end
  end

  ##
  # Platform configuration
  #
  class Configuration
    attr_accessor :repository_path,
                  :tmpdir,
                  :oauth2,
                  :api,
                  :github

    def initialize
      @oauth2 = OpenStruct.new
      @api = OpenStruct.new
      @github = OpenStruct.new
    end

    ##
    # Verify runtime configuration
    #
    def verify!
      ##
      # Global configuration
      #
      raise 'repository_path' unless Dir.exist? repository_path

      ##
      # API configuration
      #
      raise 'api.token_lifetime' unless api.token_lifetime && api.token_lifetime.is_a?(ActiveSupport::Duration)
      raise 'api.asset_url_lifetime' unless api.token_lifetime && api.token_lifetime.is_a?(ActiveSupport::Duration)
    rescue => e
      raise OpenWebslides::ConfigurationError, "Invalid `#{e}`"
    end
  end
end
