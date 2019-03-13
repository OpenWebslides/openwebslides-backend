# frozen_string_literal: true

module Oauth
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    ##
    # OmniAuth failure route
    #
    def failure
      redirect_to "/auth/sso?error=#{failure_message}"
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

      @resource.save!

      token = JWT::Auth::RefreshToken.new :subject => @resource
      redirect_to "/auth/sso?apiToken=#{token.to_jwt}&userId=#{token.subject.id}"
    rescue StandardError => e
      redirect_to "/auth/sso?error=#{CGI.escape e.message}"
    end

    protected

    def retrieve_identity
      # TODO: i18n
      raise ArgumentError, 'no email' unless email

      find_or_create_user
      find_or_create_identity

      Rails.logger.info "Authenticated user #{@resource.email} with provider #{@identity.provider}"
    end

    def find_or_create_user
      @resource = User.find_by :email => email.downcase

      return if @resource

      # New user
      attrs = {
        :email => email.downcase,
        :tos_accepted => true
      }
      @resource = User.new attrs

      sync_information
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
      @resource.name = "#{first_name} #{last_name}".strip
    end

    def email
      email = (auth_hash['info'] && auth_hash['info']['email']) || (auth_hash['extra'] && auth_hash['extra']['mail'])
      email&.downcase
    end

    def first_name
      (auth_hash['info'] && auth_hash['info']['name']) || (auth_hash['extra'] && auth_hash['extra']['givenname'])
    end

    def last_name
      auth_hash['extra'] && auth_hash['extra']['surname']
    end

    def auth_hash
      @auth_hash ||= request.env['omniauth.auth']
    end
  end
end
