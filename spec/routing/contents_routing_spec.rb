# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'contents routing', :type => :routing do
  it 'routes content endpoint' do
    route = '/api/contents/foo'

    expect(:get => route).to route_to 'contents#show', :id => 'foo'
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end

  it 'routes content topic relationship endpoint' do
    route = '/api/contents/foo/relationships/topic'
    params = { :content_id => 'foo', :relationship => 'topic' }

    expect(:get => '/api/contents/foo/topic').to route_to 'topics#get_related_resource', params.merge(:source => 'contents')

    expect(:get => route).to route_to 'contents#show_relationship', params
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end
end
