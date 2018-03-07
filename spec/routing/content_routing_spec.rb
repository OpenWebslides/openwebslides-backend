# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'content routing', :type => :routing do
  it 'routes topic content endpoint' do
    route = '/api/topics/foo/content'

    expect(:get => route).to route_to 'content#show', :topic_id => 'foo'
    expect(:post => route).not_to be_routable
    expect(:patch => route).to route_to 'content#update', :topic_id => 'foo'
    expect(:put => route).to route_to 'content#update', :topic_id => 'foo'
    expect(:delete => route).not_to be_routable
  end
end
