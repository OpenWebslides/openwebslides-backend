# frozen_string_literal: true

require 'sidekiq/web' unless Rails.env.production?

Rails.application.routes.draw do
  ##
  # Root
  #
  root :to => proc { [404, {}, []] }

  ##
  # Sidekiq UI
  #
  mount Sidekiq::Web => '/sidekiq' unless Rails.env.production?

  ##
  # OAuth2 endpoints
  #
  devise_for :users,
             :only => %i[omniauth_callbacks],
             :controllers => { :omniauth_callbacks => 'oauth/omniauth_callbacks' }

  ##
  # API endpoints
  #
  scope :api, :constraints => { :format => :json } do
    root :to => proc { [404, {}, []] }

    ##
    # Alerts API
    #
    jsonapi_resources :alerts, :only => %i[show update] do
      # User relationship
      jsonapi_related_resource :user
      jsonapi_link :user, :only => :show

      # Topic relationship
      jsonapi_related_resource :topic
      jsonapi_link :topic, :only => :show

      # Pull request relationship
      jsonapi_related_resource :pull_request
      jsonapi_link :pull_request, :only => :show

      # Subject relationship
      jsonapi_related_resource :subject
      jsonapi_link :subject, :only => :show
    end

    ##
    # User API
    #
    jsonapi_resources :users do
      # Topics relationship
      jsonapi_related_resources :topics
      jsonapi_links :topics, :only => :show

      # Collaborations relationship
      jsonapi_related_resources :collaborations
      jsonapi_links :collaborations, :only => :show

      # Alerts relationship
      jsonapi_related_resources :alerts
      jsonapi_links :alerts, :only => :show
    end

    ##
    # Topics API
    #
    jsonapi_resources :topics do
      # Relationship: Owner
      jsonapi_related_resource :user
      jsonapi_link :user, :only => :show

      # Relationship: upstream
      jsonapi_related_resource :upstream
      jsonapi_link :upstream, :only => :show

      # Relationship: forks
      jsonapi_related_resources :forks
      jsonapi_links :forks, :only => :show

      # Relationship: Collaborators
      jsonapi_related_resources :collaborators
      jsonapi_links :collaborators, :only => :show

      # Relationship: Assets
      jsonapi_related_resources :assets
      jsonapi_links :assets, :only => :show

      # Relationship: Incoming pull requests
      jsonapi_related_resources :incoming_pull_requests
      jsonapi_links :incoming_pull_requests, :only => :show

      # Relationship: Outgoing pull requests
      jsonapi_related_resources :outgoing_pull_requests
      jsonapi_links :outgoing_pull_requests, :only => :show

      # Nested resource: Assets
      jsonapi_resources :assets, :only => :create

      # Nested resource: Content
      jsonapi_resource :content, :only => %i[show update]

      # Fork
      jsonapi_resource :fork, :only => %i[create] do end
    end

    ##
    # Pull Requests API
    #
    jsonapi_resources :pull_requests, :only => %i[create show update] do
      # User relationship
      jsonapi_related_resource :user
      jsonapi_link :user, :only => :show

      # Source relationship
      jsonapi_related_resource :source
      jsonapi_link :source, :only => :show

      # Target relationship
      jsonapi_related_resource :target
      jsonapi_link :target, :only => :show
    end

    ##
    # Assets API
    #
    jsonapi_resources :assets, :only => %i[show destroy] do
      # Topic relationship
      jsonapi_related_resource :topic
      jsonapi_link :topic, :only => :show

      get '/raw' => 'assets#raw'
    end

    ##
    # Recent Activity (feed) API (immutable)
    #
    jsonapi_resources :feed_items, :only => %i[index] do end

    ##
    # Authentication API
    #
    jsonapi_resource :token, :only => %i[create update destroy] do end
    jsonapi_resource :confirmation, :only => %i[create update] do end
    jsonapi_resource :password, :only => %i[create update] do end
  end
end
