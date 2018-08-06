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
    attr_accessor :tmpdir,
                  :repository,
                  :oauth2,
                  :api

    def initialize
      @repository = OpenStruct.new
      @oauth2 = OpenStruct.new
      @api = OpenStruct.new
    end

    ##
    # Verify runtime configuration
    #
    def verify!
      ##
      # Global configuration
      #
      raise 'repository.path' unless Dir.exist? repository.path
      raise 'repository.version' if Semverse::Version.new(repository.version).nil?

      ##
      # API configuration
      #
      raise 'api.token_lifetime' unless api.token_lifetime && api.token_lifetime.is_a?(ActiveSupport::Duration)
      raise 'api.asset_url_lifetime' unless api.token_lifetime && api.token_lifetime.is_a?(ActiveSupport::Duration)
      raise 'repository.version' if Semverse::Version.new(api.version).nil?
    end
  end
end
