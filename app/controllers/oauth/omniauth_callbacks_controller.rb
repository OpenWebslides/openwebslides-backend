# frozen_string_literal: true

module Oauth
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    ##
    # OmniAuth passthru
    #
    def passthru
      super
    end

    ##
    # OmniAuth failure route
    #
    def failure
      redirect_to root_path :oauth_error => failure_message
    end

    ##
    # OmniAuth provider callback routes
    def facebook
      callback
    end

    def google_oauth2
      callback
    end

    def cas
      callback
    end

    ##
    # OmniAuth callback
    #
    def callback
      retrieve_identity
      sync_information

      @resource.save

      token = JWT::Auth::Token.from_user @resource
      redirect_to "/auth/sso?apiToken=#{token.to_jwt}&userId=#{token.subject.id}"
    end

    protected

    def auth_hash
      @auth_hash ||= request.env['omniauth.auth']
    end

    def retrieve_identity
      raise unless email

      find_or_create_user
      find_or_create_identity

      Rails.logger.info "Authenticated user #{@resource.email} with provider #{@identity.provider}"
    end

    private

    def find_or_create_user
      @resource = User.find_by :email => email.downcase

      return if @resource

      # New user
      attrs = {
        :name => name,
        :email => email.downcase,
        :tos_accepted => true
      }
      @resource = User.new attrs

      set_random_password

      @resource.skip_confirmation!
      @resource.save!

      Rails.logger.info "Authenticated new user #{@resource.email}"
    end

    def find_or_create_identity
      @identity = @resource.identities.where(:uid => auth_hash['uid'], :provider => auth_hash['provider']).first

      return if @identity

      # New identity
      @identity = @resource.identities.build :uid => auth_hash['uid'], :provider => auth_hash['provider']
      @identity.save!

      Rails.logger.info "Authenticated user #{@resource.email} with new provider #{@identity.provider}"
    end

    def set_random_password
      # Set crazy password for new oauth users. this is only used to prevent access via email sign-in.
      password = SecureRandom.urlsafe_base64(nil, false)
      @resource.password = password
      @resource.password_confirmation = password
    end

    def sync_information
      @resource.name = name
    end

    def email
      (auth_hash['info']['email'] || (auth_hash['extra'] && auth_hash['extra']['mail'])).downcase
    end

    def name
      "#{first_name} #{last_name}".strip
    end

    def first_name
      auth_hash['info']['name'] || (auth_hash['extra'] && auth_hash['extra']['givenname'])
    end

    def last_name
      auth_hash['extra'] && auth_hash['extra']['surname']
    end
  end
end
