# frozen_string_literal: true

require 'ostruct'

module OpenWebslides
  MEDIA_TYPE = 'application/vnd.openwebslides+json'

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
                  :lockdir,
                  :repository,
                  :oauth2,
                  :api,
                  :queue

    def initialize
      @repository = OpenStruct.new
      @oauth2 = OpenStruct.new
      @api = OpenStruct.new
      @queue = OpenStruct.new
    end

    ##
    # Verify runtime configuration
    #
    def verify!
      verify_global!
      verify_repository!
      verify_api!
      verify_queue!
    end

    private

    ##
    # Verify global configuration
    #
    def verify_global!
      FileUtils.mkdir_p tmpdir unless Dir.exist? tmpdir
      FileUtils.mkdir_p lockdir unless Dir.exist? lockdir
    end

    ##
    # Verify repository configuration
    #
    def verify_repository!
      FileUtils.mkdir_p repository.path unless Dir.exist? repository.path
      raise 'repository.version' if Semverse::Version.new(repository.version).nil?
    end

    ##
    # Verify API configuration
    #
    def verify_api!
      raise 'repository.version' if Semverse::Version.new(api.version).nil?
    end

    ##
    # Verify background queue configuration
    #
    def verify_queue!
      raise 'queue.timeout' unless queue.timeout&.is_a? ActiveSupport::Duration
    end
  end
end
