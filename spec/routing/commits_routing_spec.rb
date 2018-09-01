# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'commits routing', :type => :routing do
  it 'routes commits endpoint' do
    route = '/api/topics/foo/commits'

    expect(:get => route).not_to be_routable
    expect(:post => route).to route_to 'commits#create'
    expect(:patch => route).not_to be_routable
    expect(:put => route).not_to be_routable
    expect(:delete => route).not_to be_routable
  end
end
