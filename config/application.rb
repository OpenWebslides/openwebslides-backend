# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
# require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require "action_cable/engine"
# require 'rails/test_unit/railtie'

# Allow GraphiQL to work in Rails API-only mode
require 'sprockets/railtie' unless Rails.env.production?

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Eager load monkey patches
Dir[File.join __dir__, '..', 'lib', '**', '*.rb'].each { |f| require f }

##
# The Open Webslides platform
#
module OpenWebslides
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    # Autoload lib
    config.autoload_paths += %W[#{config.root}/lib]
    config.eager_load_paths += %W[#{config.root}/lib]

    config.before_initialize do
      require_relative 'openwebslides'
    end

    config.to_prepare do
      # Configure Devise mailer layout
      Devise::Mailer.layout 'mailer'
    end
  end
end
