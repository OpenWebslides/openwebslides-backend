# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'fork routing', :type => :routing do
  it 'routes topics fork endpoint' do
    route = '/api/topics/foo/fork'

    expect(:get => route).not_to be_routable
    expect(:post => route).to route_to 'fork#create', :topic_id => 'foo'
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end
end
