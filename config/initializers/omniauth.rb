# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  before_callback_phase do |env|
    # TODO: verify state
    query_params = Rack::Utils.parse_nested_query env['QUERY_STRING']
    env['rack.session']['omniauth.state'] = query_params['state']
  end

  provider :cas,
           :host => 'login.ugent.be'

  provider :google_oauth2,
           OpenWebslides.config.oauth2.google_id,
           OpenWebslides.config.oauth2.google_secret

  provider :facebook,
           OpenWebslides.config.oauth2.facebook_id,
           OpenWebslides.config.oauth2.facebook_secret,
           :scope => 'email'
end
