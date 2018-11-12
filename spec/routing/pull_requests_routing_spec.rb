# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pull requests routing', :type => :routing do
  it 'routes pull request endpoint' do
    route = '/api/pullRequests/foo'

    expect(:get => route).to route_to 'pull_requests#show', :id => 'foo'
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end

  it 'routes pull_request user relationship endpoint' do
    route = '/api/pullRequests/foo/relationships/user'
    params = { :pull_request_id => 'foo', :relationship => 'user' }

    expect(:get => '/api/pullRequests/foo/user').to route_to 'users#get_related_resource', params.merge(:source => 'pull_requests')

    expect(:get => route).to route_to 'pull_requests#show_relationship', params
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end

  it 'routes pull_request source relationship endpoint' do
    route = '/api/pullRequests/foo/relationships/source'
    params = { :pull_request_id => 'foo', :relationship => 'source' }

    expect(:get => '/api/pullRequests/foo/source').to route_to 'topics#get_related_resource', params.merge(:source => 'pull_requests')

    expect(:get => route).to route_to 'pull_requests#show_relationship', params
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end

  it 'routes pull_request target relationship endpoint' do
    route = '/api/pullRequests/foo/relationships/target'
    params = { :pull_request_id => 'foo', :relationship => 'target' }

    expect(:get => '/api/pullRequests/foo/target').to route_to 'topics#get_related_resource', params.merge(:source => 'pull_requests')

    expect(:get => route).to route_to 'pull_requests#show_relationship', params
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end
end
