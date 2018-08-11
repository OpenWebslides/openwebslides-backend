# frozen_string_literal: true

OmniAuth.config.on_failure = proc do |env|
  # Override Devise OmniAuth failure mapping path, because we use a custom path for the callback
  env['devise.mapping'] = Devise.mappings[:user]
  controller_name  = ActiveSupport::Inflector.camelize(env['devise.mapping'].controllers[:omniauth_callbacks])
  controller_klass = ActiveSupport::Inflector.constantize("#{controller_name}Controller")
  controller_klass.action(:failure).call(env)
end
