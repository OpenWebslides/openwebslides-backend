# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '@feed_items routing', :type => :routing do
  it 'routes @feed_items endpoint' do
    route = '/api/feed-items'

    expect(:get => route).to route_to 'feed_items#index'
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end

  it 'routes feed_item endpoint' do
    route = '/api/feed-items/foo'

    expect(:get => route).not_to be_routable
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end
end
