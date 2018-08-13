# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'omniauth routing', :type => :routing do
  describe 'cas' do
    it 'routes provider redirect' do
      params = { :controller => 'oauth/omniauth_callbacks', :action => 'passthru' }
      expect(:get => '/oauth/cas').to route_to params
      expect(:post => '/oauth/cas').to route_to params
    end

    it 'routes provider callback' do
      params = { :controller => 'oauth/omniauth_callbacks', :action => 'cas' }
      expect(:get => '/oauth/cas/callback').to route_to params
      expect(:post => '/oauth/cas/callback').to route_to params
    end
  end

  describe 'facebook' do
    it 'routes provider redirect' do
      params = { :controller => 'oauth/omniauth_callbacks', :action => 'passthru' }
      expect(:get => '/oauth/facebook').to route_to params
      expect(:post => '/oauth/facebook').to route_to params
    end

    it 'routes provider callback' do
      params = { :controller => 'oauth/omniauth_callbacks', :action => 'facebook' }
      expect(:get => '/oauth/facebook/callback').to route_to params
      expect(:post => '/oauth/facebook/callback').to route_to params
    end
  end

  describe 'google' do
    it 'routes provider redirect' do
      params = { :controller => 'oauth/omniauth_callbacks', :action => 'passthru' }
      expect(:get => '/oauth/google_oauth2').to route_to params
      expect(:post => '/oauth/google_oauth2').to route_to params
    end

    it 'routes provider callback' do
      params = { :controller => 'oauth/omniauth_callbacks', :action => 'google_oauth2' }
      expect(:get => '/oauth/google_oauth2/callback').to route_to params
      expect(:post => '/oauth/google_oauth2/callback').to route_to params
    end
  end
end
