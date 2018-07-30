# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'notifications routing', :type => :routing do
  it 'routes notifications endpoint' do
    route = '/api/notifications'

    expect(:get => route).to route_to 'notifications#index'
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end

  it 'routes notification endpoint' do
    route = '/api/notifications/foo'

    expect(:get => route).not_to be_routable
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:post => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end
end
