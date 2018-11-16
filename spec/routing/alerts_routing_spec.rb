# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'alerts routing', :type => :routing do
  it 'routes alert endpoint' do
    route = '/api/alerts/foo'

    expect(:get => route).to route_to 'alerts#show', :id => 'foo'
    expect(:patch => route).to route_to 'alerts#update', :id => 'foo'
    expect(:put => route).to route_to 'alerts#update', :id => 'foo'
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end

  it 'routes alert user relationship endpoint' do
    route = '/api/alerts/foo/relationships/user'
    params = { :alert_id => 'foo', :relationship => 'user' }

    expect(:get => '/api/alerts/foo/user').to route_to 'users#get_related_resource', params.merge(:source => 'alerts')

    expect(:get => route).to route_to 'alerts#show_relationship', params
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end

  it 'routes alert topic relationship endpoint' do
    route = '/api/alerts/foo/relationships/topic'
    params = { :alert_id => 'foo', :relationship => 'topic' }

    expect(:get => '/api/alerts/foo/topic').to route_to 'topics#get_related_resource', params.merge(:source => 'alerts')

    expect(:get => route).to route_to 'alerts#show_relationship', params
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end

  it 'routes alert pull_request relationship endpoint' do
    route = '/api/alerts/foo/relationships/pullRequest'
    params = { :alert_id => 'foo', :relationship => 'pull_request' }

    expect(:get => '/api/alerts/foo/pullRequest').to route_to 'pull_requests#get_related_resource', params.merge(:source => 'alerts')

    expect(:get => route).to route_to 'alerts#show_relationship', params
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end

  it 'routes alert subject relationship endpoint' do
    route = '/api/alerts/foo/relationships/subject'
    params = { :alert_id => 'foo', :relationship => 'subject' }

    expect(:get => '/api/alerts/foo/subject').to route_to 'users#get_related_resource', params.merge(:source => 'alerts')

    expect(:get => route).to route_to 'alerts#show_relationship', params
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end
end
