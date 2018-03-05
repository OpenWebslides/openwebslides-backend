# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'assets routing', :type => :routing do
  it 'routes assets endpoint' do
    route = '/api/topics/foo/assets'
    params = { :topic_id => 'foo', :relationship => 'assets', :source => 'topics' }

    expect(:get => route).to route_to 'assets#get_related_resources', params
    expect(:post => route).to route_to 'assets#create', :topic_id => 'foo'
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end

  it 'routes asset endpoint' do
    route = '/api/assets/foo'

    expect(:get => route).to route_to 'assets#show', :id => 'foo'
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).to route_to 'assets#destroy', :id => 'foo'
  end

  it 'routes raw asset endpoint' do
    expect(:get => '/api/assets/foo/raw').to route_to 'assets#raw', :asset_id => 'foo'
  end

  it 'routes asset topic relationship endpoint' do
    route = '/api/assets/foo/relationships/topic'
    params = { :asset_id => 'foo', :relationship => 'topic' }

    expect(:get => '/api/assets/foo/topic').to route_to 'topics#get_related_resource', params.merge(:source => 'assets')

    expect(:get => route).to route_to 'assets#show_relationship', params
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end
end
